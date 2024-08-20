repos=$(ls -d */)
for repo_dir in $repos; do
    echo $repo_dir
    cd $repo_dir 
    git pull
    cd ..
done