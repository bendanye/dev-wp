# Grep signals by ecosystem

Starting points for finding candidates. Each hit still needs to be read
against the production code — these patterns over-match by design.

## Contents
- Cross-language
- Python (pytest / unittest / unittest.mock)
- JavaScript / TypeScript (Jest / Vitest / Mocha / Testing Library)
- Java / Kotlin (JUnit / Mockito / MockK / AssertJ)
- Go
- C# (.NET: xUnit / NUnit / Moq / NSubstitute)

## Cross-language

| Smell | What to look for |
|---|---|
| No assertion | test bodies with no `assert`/`expect`/`verify`/`should` — list test functions, then grep each body |
| Weak assertion | `NotNull`, `toBeDefined`, `toBeTruthy`, `assert result$`, `isNotEmpty` as the *only* assertion |
| Expectation built from prod | test imports the same function it tests and calls it while building `expected` |
| Swallowed failure | `try:` / `try {` in test bodies; `catch (Exception`; `except Exception: pass` |
| Snapshots | `__snapshots__/`, `.snap`, `toMatchSnapshot`, `approvals`, `syrupy`, `snapshottest`, `Verify(` — check size and git churn (`git log --oneline -- <snap> \| wc -l`) |
| Reflection / privates | `setAccessible`, `getDeclaredField`, `ReflectionTestUtils`, `Whitebox`, `._[a-z]` attribute access on SUT, `@VisibleForTesting` |
| Fakes | files/classes named `Fake*`, `InMemory*`, `Stub*`, `*Double`, `fixtures/`, `__mocks__/`, `testdata/` |
| Skipped/neutered | `@Disabled`, `@Ignore`, `skip`, `xit`, `it.skip`, `t.Skip`, `pytest.mark.skip` (not in scope per se, but note large clusters) |

## Python

- Un-specced mocks: `Mock()`, `MagicMock()` without `spec=`/`spec_set=`;
  `patch(...)` without `autospec=True`. These accept any attribute and any
  call signature, so stubs can drift from the real interface silently.
- Assertion methods that never run: `mock.method.assert_called_once` with no
  `()` (bare attribute access, a silent no-op), or assertion-looking
  attributes such as `called_once_with` / `assert_called_once_wiht`. Python
  3.12+ raises `AttributeError` for many such typos on un-specced mocks, older
  versions return a truthy child `Mock` — check the Python version in use.
- `assert mock.called` / `assert mock.method.called` — the first is a typo
  magnet; check the attribute exists.
- `return_value = {...}` dicts for HTTP/DB clients — compare keys against the
  real client's return type or recorded responses.
- `side_effect = Exception` — is that exception type ever raised by the real
  dependency? Check the library (`requests.exceptions.*`, `botocore.exceptions.ClientError`, ...).
- `@patch('pkg.module.name')` stacks of 4+ decorators on one test —
  usually structure-sensitive.
- `pytest.raises(Exception)` (too broad — passes on any error, including a
  `TypeError` from a broken test).
- `freezegun`/`time-machine` absent but `datetime.now()` used — not this
  skill's concern unless it makes a test tautological.

## JavaScript / TypeScript

- `jest.mock('<module>')` automocks: every export returns `undefined` unless
  stubbed; check that the code under test isn't simply receiving `undefined`.
- `mockResolvedValue({...})` / `mockReturnValue({...})` objects, especially
  with `as any`, `as unknown as`, or `// @ts-ignore` nearby — type checking
  was switched off exactly where the shape could drift.
- `jest.spyOn(sut, ...)` on the subject under test (partial mock of SUT).
- `toHaveBeenCalledTimes(n)`, `toHaveBeenNthCalledWith` on internal helpers.
- `expect(...)` inside `.then(` without `return`/`await`; `done` callbacks
  with `expect` in a different tick; `expect.assertions(n)` absent in
  async error tests.
- Testing Library: `container.querySelector`, `getByTestId` everywhere,
  `.className` assertions, `nth-child` selectors — structure-sensitive vs
  `getByRole`/`getByText`.
- MSW / nock handlers: compare response bodies to the real API schema/OpenAPI.

## Java / Kotlin

- `verify(` / `verifyNoMoreInteractions` / `inOrder(` / `times(` — check
  whether the verified call is an observable side effect or an internal step.
- `when(x.foo(any())).thenReturn(y)` followed by `assertEquals(y, result)`
  with no transformation — asserts the stub.
- `@Spy` / `spy(` / `doReturn(...).when(sut)` — partial mocking of SUT.
- `mock(SomeDto.class)` / `mock(List.class)` — mocking values.
- Mockito `lenient()` / `Strictness.LENIENT` / `MockitoJUnitRunner.Silent` —
  unused stubs are hidden; often a sign stubs drifted from what the code calls.
- `thenReturn(null)` where the real method returns `Optional` or never null.
- `thenThrow(new RuntimeException())` — does the real dependency throw that?
- AssertJ: `assertThat(x);` with no terminal assertion; `.isNotNull()` only.
- `ReflectionTestUtils.setField`, `Whitebox`, PowerMock (`mockStatic`,
  `whenNew`) — almost always structure-sensitive.
- Kotlin MockK: `every { ... } returns`, `relaxed = true` (like un-specced
  mocks), `verify(exactly = n)`.

## Go

- Hand-written fakes implementing an interface — compare each method's
  behaviour with the real implementation, especially error returns
  (`nil, nil` fakes where real returns `nil, ErrNotFound`).
- `gomock` `.EXPECT()...Times(n)` / `InOrder` on internal collaborators.
- Tests with `if err != nil { t.Log(...) }` instead of `t.Fatal` — swallowed failure.
- Golden files in `testdata/` updated via `-update` flag — check churn.
- `reflect.DeepEqual` on structs with unexported/incidental fields.

## C#

- Moq `Setup(...).Returns(...)` then `Assert.Equal(sameValue, result)`.
- `Verify(..., Times.Once)` on internal collaborators; `MockBehavior.Loose`
  (default) hides unconfigured calls.
- `It.IsAny<T>()` everywhere — the test can't fail on wrong arguments.
- `InternalsVisibleTo` used to test internals directly.
- `Assert.NotNull(result)` as the only assertion.
