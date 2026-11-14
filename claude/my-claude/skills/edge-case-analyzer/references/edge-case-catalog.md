# Edge Case Catalog

A menu of values and situations to try. Pick what applies to the code in front
of you; don't enumerate every item in the report.

## Contents

- Numbers
- Strings and text
- Collections
- Optional / missing values
- Dates, times, and locale
- Files, paths, and I/O
- External dependencies (HTTP, DB, queues, caches)
- State and lifecycle
- Concurrency
- Resources and scale
- Security-relevant inputs
- Language-specific traps

## Numbers

- `0`, `-0`, `1`, `-1`
- Exactly at each threshold in the code, and ±1 (or ±epsilon for floats)
- Min/max of the type: `INT_MAX`, `Long.MIN_VALUE`, `Number.MAX_SAFE_INTEGER`
- Overflow on add/multiply; `abs(MIN_VALUE)` stays negative in two's complement
- Division or modulo by zero; modulo of negative numbers (sign differs by language)
- Floats: `NaN`, `Infinity`, `0.1 + 0.2`, rounding mode (banker's vs half-up),
  comparing floats with `==`, money stored as float
- Integer division truncation (`5 / 2`), implicit int↔float conversion
- Numeric strings: `"  42 "`, `"4.0"`, `"1e3"`, `"1,000"`, `"0x1F"`, `"+5"`,
  `"٣"` (non-ASCII digits), empty string
- Percentages / ratios where the denominator can be zero

## Strings and text

- Empty `""`, whitespace-only `"   "`, leading/trailing whitespace
- Very long strings; strings exceeding DB column length (silent truncation?)
- Unicode: accents (composed vs decomposed — `é` vs `é`), emoji and
  surrogate pairs (length ≠ character count), RTL text, zero-width characters
- Case: Turkish `İ/i`, German `ß` uppercasing to `SS`, case-insensitive compare
- Newlines `\n` vs `\r\n`, tabs, NUL bytes `\0`
- Delimiters inside values (commas in CSV, quotes in JSON/SQL, `/` in paths)
- Encoding mismatches (UTF-8 vs Latin-1, BOM at start of file)
- Regex: catastrophic backtracking, unanchored patterns matching substrings,
  `.` not matching newline

## Collections

- Empty; exactly one element; exactly two (pairwise logic)
- Duplicates; all elements equal; already sorted / reverse sorted
- Very large (performance, memory, pagination limits)
- Containing `null` / `None` elements
- First and last element handling (off-by-one in loops and slices)
- Modifying a collection while iterating it
- Maps: missing key, key present with `null` value, key collisions,
  iteration order assumptions
- Nested / recursive structures, cycles (infinite recursion in serializers)

## Optional / missing values

- `null` / `None` / `undefined` / `nil` for every parameter and field
- Field missing vs present-but-null vs present-but-empty (often handled differently)
- Default values that are mutable and shared (Python `def f(x=[])`)
- Optional chaining that silently yields `undefined` and propagates

## Dates, times, and locale

- Leap day (Feb 29), Feb 28→Mar 1 arithmetic, non-leap century (1900, 2100)
- Month-end: adding one month to Jan 31
- DST transitions: nonexistent local time (spring forward), duplicated hour
  (fall back), day with 23 or 25 hours
- Timezones: naive vs aware datetimes mixed, server TZ ≠ user TZ, UTC offset
  changes, "end of day" in which zone
- Year boundaries, week numbering (ISO week 53), epoch 0, negative timestamps,
  year 2038 for 32-bit seconds, milliseconds vs seconds confusion
- Date parsing: `01/02/2024` (Jan 2 or Feb 1?), two-digit years
- Locale: decimal comma `1,5`, thousands separators, sorting/collation

## Files, paths, and I/O

- File missing, empty, unreadable (permissions), is a directory, is a symlink
- Very large file read fully into memory
- Partial writes / crash mid-write (is there a temp-file-then-rename?)
- Paths with spaces, unicode, `..`, absolute vs relative, trailing slash,
  Windows separators, case-insensitive filesystems
- Disk full, file locked by another process
- Trailing newline present or absent; last line without newline
- Malformed input: truncated JSON, extra columns in CSV, wrong header

## External dependencies (HTTP, DB, queues, caches)

- Timeout; connection refused; DNS failure
- Non-2xx status; 2xx with error body; empty body; HTML instead of JSON
- Response missing fields, extra fields, wrong types, `null` where object expected
- Pagination: zero results, exactly one page, last page partial, cursor reuse
- Rate limiting (429) and retry storms; retrying a non-idempotent call
- DB: zero rows, more than one row where one expected, unique constraint
  violation, deadlock, transaction rolled back after side effects were sent
- Cache: miss, stale entry, cache unavailable, thundering herd on expiry
- Queue: duplicate delivery, out-of-order delivery, poison message, consumer
  crash after processing but before ack

## State and lifecycle

- First call ever (no prior state, empty tables, missing config)
- Called twice (idempotency); called after a previous failure
- Invalid state transitions (cancel after completion, refund before payment)
- Partially initialised objects; use after close/dispose
- Exception thrown midway leaving state half-updated
- Global/static state leaking between calls or tests

## Concurrency

- Two callers performing check-then-act (TOCTOU) on the same record
- Lost updates (read-modify-write without locking/versioning)
- Non-thread-safe shared objects (e.g. `SimpleDateFormat`, plain `HashMap`)
- Async: unawaited promises, missing error handling on background tasks,
  ordering assumptions between async operations
- Lock ordering → deadlock; holding a lock across I/O

## Resources and scale

- Quadratic algorithms on realistic input sizes (nested loops, repeated
  string concatenation, `list.contains` in a loop)
- Unbounded growth: caches without eviction, listeners never removed, queues
  without back-pressure
- Unclosed files, connections, streams on error paths
- Deep recursion → stack overflow

## Security-relevant inputs

- SQL/command/LDAP/template injection via string concatenation
- Path traversal (`../../etc/passwd`) in user-supplied filenames
- Unescaped output (XSS) in HTML contexts
- IDs belonging to another user/tenant (authorization on every lookup?)
- Oversized payloads, zip bombs, billion-laughs XML
- Error messages or logs exposing secrets or internals

## Language-specific traps

**Python**: mutable default args; `is` vs `==`; truthiness (`0`, `""`, `[]`
are falsy — `if not x` conflates them with `None`); integer `//` with
negatives floors; `dict` ordering; late binding in closures/lambdas in loops;
broad `except:` swallowing `KeyboardInterrupt`.

**JavaScript / TypeScript**: `==` coercion; `NaN !== NaN`; `parseInt("08")`,
`parseInt` without radix; `[] + {}`; `Array.sort()` sorts lexically by default;
`typeof null === "object"`; `0`/`""` falsy in `||` defaults (use `??`);
floating point for money; TS types not enforced at runtime on external data.

**Java / Kotlin**: `Integer` cache makes `==` work for small values only;
autounboxing `null` → NPE; `equals`/`hashCode` mismatch; `substring`/`split`
edge behaviour (trailing empty strings dropped by `split`); `BigDecimal.equals`
compares scale (`1.0 ≠ 1.00`); `ConcurrentModificationException`;
`Optional.get()` on empty.

**Go**: nil maps panic on write; nil interface vs interface holding nil
pointer; loop variable capture (pre-1.22); unchecked errors; slice aliasing
after `append`; integer overflow wraps silently.

**C# / .NET**: `async void`; `DateTime.Kind` confusion; `First()` vs
`FirstOrDefault()`; culture-sensitive `ToUpper`/`Parse`; LINQ deferred
execution evaluated multiple times.

**SQL**: `NULL` comparisons (`= NULL` is never true; `NOT IN` with a NULL
returns nothing); integer division; implicit casts; `LIKE` wildcards in user
input; `BETWEEN` with timestamps excluding the last day.

**Shell**: unquoted variables with spaces/globs; `set -e` not triggering in
pipelines or conditionals; filenames starting with `-`; empty variable in
`rm -rf "$DIR/"`.
