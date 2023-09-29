# Prerequisites

This excercise assumes that you have finished "Exercice: basic workflow" and that you continue to make changes in the repository you created there.

# Excercises

## Check what branch you are on

You can see what branch you are on with the git status command:

```bash
$ git status
On branch main
nothing to commit, working tree clean
```

There is also a git branch command. It is used for a lot of branch-related operations, but its basic function is to display the branches in your repository and highlight the one you are currently on:

```bash
$ git branch
* main
```

As you can see, we are on branch "main". (Remember that it is a builtin convention that Git creates an initial branch "main").

## Create a branch at the HEAD

Now let's create a new branch. There are a few ways to do this. We will use the git branch command to begin with.

If you just run the command and give it a name, a branch will be created on the current HEAD commit (that is, the commit you have currently checked out). Let's try this:

```bash
$ git branch branch-1
$ git branch
  branch-1
* main
```

We have created "banch-1"! You can add '-v' to the command to see what commit each branch points to:

```bash
$ git branch -v
  branch-1 9f7578f Write "baz" in file1.txt
* main     9f7578f Write "baz" in file1.txt
```

You will also see it in the log:

```bash
$ git log --oneline
9f7578f (HEAD -> main, branch-1) Write "baz" in file1.txt
6202970 Write "bar" in file1.txt
659ccda Add file1.txt
```

## Create a branch anywhere

You can also create a branch anywhere in the commit tree by specifying a commit hash or a reference to a commit (like another branch or a tag).

Remember that the commit hashes will be different for you than in the examples here, so first you need to list the commits currently in your repository:

```bash
$ git log --oneline
9f7578f (HEAD -> main, branch-1) Write "baz" in file1.txt
6202970 Write "bar" in file1.txt
659ccda Add file1.txt
```

Copy the commit hashes from your output and use in the following!

Let's create a branch on the second commit as well:

```bash
$ git branch branch-2 6202970
$ git log --oneline
9f7578f (HEAD -> main, branch-1) Write "baz" in file1.txt
6202970 (branch-2) Write "bar" in file1.txt
659ccda Add file1.txt
```

## Switch branch

So now we have 3 branches: main, branch-1 and branch-2.

You can use the branch names to checkout the files as they are at that point in history. You can do this both with the git checkout command and the git switch command. The switch command is newer and was added for the purpose of switching branches (the checkout command does more), so we will use that.

Switch to branch-2:

```bash
$ git switch branch-2
Switched to branch 'branch-2'
$ git status
On branch branch-2
nothing to commit, working tree clean
$ git log --oneline
6202970 (HEAD -> branch-2) Write "bar" in file1.txt
659ccda Add file1.txt
```

As you can see, we are now on a different commit and the files in our workspace have been updated.

## Make a change on branch-2

Now let us make a change on branch-2:

```bash
$ echo "three" >> file1.txt
$ git commit -am 'Write "three" in file1.txt'
[branch-2 2bb25b4] Write "three" in file1.txt
 1 file changed, 1 insertion(+)
 $ git log --oneline
2bb25b4 (HEAD -> branch-2) Write "three" in file1.txt
6202970 Write "bar" in file1.txt
659ccda Add file1.txt
 ```

## View the commit graph

So now history has diverged! On the main/branch-1 branch "baz" was written in file1.txt after "bar", but on branch-2 "three" was written. There will be a (very) small tree of commits connected by the parent references. You can see it by using the '--graph' flag on the git log command. We also use '--all' because we want to dislay all branches, not just the currently checked out one.

```branch
$ git log --graph --all --oneline
* 2bb25b4 (HEAD -> branch-2) Write "three" in file1.txt
| * 9f7578f (main, branch-1) Write "baz" in file1.txt
|/
* 6202970 Write "bar" in file1.txt
* 659ccda Add file1.txt
```

## Make changes on branch-1 and main

Now we'll make things more interesting by making changes on both branch-1 and main:

```bash
$ git switch branch-1
Switched to branch 'branch-1'
$ echo "quattro" >> file1.txt
$ git status
On branch branch-1
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   file1.txt

no changes added to commit (use "git add" and/or "git commit -a")
$ git commit -am 'Write "quattro" in file1.txt'
[branch-1 4d97b22] Write "quattro" in file1.txt
 1 file changed, 2 insertions(+)

$ git switch main
Switched to branch 'main'
$ echo "qux" >> file1.txt
$ git status
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   file1.txt

no changes added to commit (use "git add" and/or "git commit -a")
$ git commit -am 'Write "qux" in file1.txt'
[main 5bdc6b9] Write "qux" in file1.txt
 1 file changed, 1 insertion(+)
```

Now history is much more interesting:

```bash
$ git log --graph --all --oneline
* 5bdc6b9 (HEAD -> main) Write "qux" in file1.txt
| * 4d97b22 (branch-1) Write "quattro" in file1.txt
|/
* 9f7578f Write "baz" in file1.txt
| * 2bb25b4 (branch-2) Write "three" in file1.txt
|/
* 6202970 Write "bar" in file1.txt
* 659ccda Add file1.txt
````

This is the basics of branches in Git.