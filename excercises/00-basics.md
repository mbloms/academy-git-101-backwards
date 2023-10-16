# Prerequisites

This excercise assumes the following:

- You have installed Git (see https://git-scm.com/downloads for instructions)
- You run the commands in a Bash shell terminal (on Windows, use Git Bash or equivalent)
- You have configured Git with your name and email with the following commands:

      git config --global user.name "Your Name"
      git config --global user.email "your.name@omegapoint.se"

# Instructions

This exercise is designed for you to follow along. There will be short texts describing and explaining what should be done followed by code blocks with the commands to run. 

You should place these instructions in one window and have a terminal window open beside it so that you can type the commands.

In the code blocks, every line starting with a $ sign is a command to run (you skip the $ sign itself!). Every line starting with a # sign is a comment that explains or give some more detail about the following command. All other lines are output 

Most of the steps assume that you have run every step up to that point, so make sure you run every command in the correct order or that your Git repository is in an equivalent state.

# Excercises

## Create a repository

The first task is to create a Git repository. We will use it to demonstrate the basics of Git, but you should keep this practice in your toolbox, because it is a great way of learning and troubleshooting Git. If you are unsure of what has happened or how something works, create an empty repository to experiment with!

To create a repository, you first create an empty directory. This will be your working directory where you will add your files. In that directory, you run the `git init` command:

```bash
$ mkdir git-101
$ cd git-101
$ git init
Initialized empty Git repository in /Users/ansig/Scratch/git-101/.git/
```

This will have added a (hidden) directory named `.git` in your working directory. This is the Git repository! At this point, it will only contain some basic files:

```bash
$ find .git/
.git/
.git/config
.git/objects
.git/objects/pack
.git/objects/info
.git/HEAD
.git/info
.git/info/exclude
.git/description
.git/hooks
.git/hooks/commit-msg.sample
.git/hooks/pre-rebase.sample
.git/hooks/pre-commit.sample
.git/hooks/applypatch-msg.sample
.git/hooks/fsmonitor-watchman.sample
.git/hooks/pre-receive.sample
.git/hooks/prepare-commit-msg.sample
.git/hooks/post-update.sample
.git/hooks/pre-merge-commit.sample
.git/hooks/pre-applypatch.sample
.git/hooks/pre-push.sample
.git/hooks/update.sample
.git/hooks/push-to-checkout.sample
.git/refs
.git/refs/heads
.git/refs/tags
```

This course will not go into any more details about what is in this directory and you will typically not have to look into it during everyday work, but it is important to know that this is your Git repository.

## Check status

The `git status` command is something that you should use often. Its basic function is to display the current state of the working directory compared to what has been commited into the Git repository.

When you have created an empty repository, this will be the output:

```bash
$ git status
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

## Make initial commit

Now let's make some changes and track them with Git. 

In the following examples we will use the `echo` command to write pieces of text into files, but you can use a text editor as well. If you do, just ignore the lines with `echo` command and make the corresponding change with your editor (don't forget to save the file!).

First create a file with just one line that says "foo":

```bash
$ echo "foo" > file1.txt
```

With `git status` we see that there is a new file added, but that it is not yet tracked by Git:

```bash
$ git status
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
    file1.txt

nothing added to commit but untracked files present (use "git add" to track)
```

The next step is to add it to the staging area ("staging" it) using the `git add` command. After this, the status command will say that one change is ready to be commited:

```bash
$ git add file1.txt
$ git status
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
    new file:   file1.txt
```

So let us do that with the `git commit` command. Notice that we must add a message describing what is changed when creating a commit:

```bash
$ git commit -m 'Add file1.txt'
[main (root-commit) 659ccda] Add file1.txt
 1 file changed, 1 insertion(+)
 create mode 100644 file1.txt
```

Status will now show us that there are no changes in the working directory anymore. This means that the working directory and the current commit (the HEAD) in the Git repository are exactly the same.

```bash
$ git status

On branch main

nothing to commit, working tree clean
```

This is the basic workflow of version control with Git: 

  1. make changes in the working directory
  2. add what you want to the staging area (or "stage" it for short)
  3. make a commit with a message describing the change

## Change a file

Now we shall make a change to the file. We write "bar" into a new line:

```bash
$ echo "bar" >> file1.txt
```

This time, since we have changed an already existing file, status will say that a file has been modified:

```bash
$ git status
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   file1.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

We can also see what has changed with the `git diff` command:

```bash
$ git diff
diff --git a/file1.txt b/file1.txt
index 257cc56..3bd1f0e 100644
--- a/file1.txt
+++ b/file1.txt
@@ -1 +1,2 @@
 foo
+bar
```

Once again, we stage the file. Note that we use a `.` with the add command here instead of specifying the filename. This tells Git that we want to stage all changes in the working directory.

```bash
$ git add .
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   file1.txt
```

Now you will see something a bit strange: after we have staged the file, there is no longer any difference!

```bash
$ git diff
```

This is because the diff commands default behaviour is to compare what is in your working directory with what is in your staging area. Since you have added all changes (altough you did not commit them yet), they are now the same in your working directory as in the staging area, so there is no difference.

You can make the diff command show you what changes are currently in the staging area - i.e. what is about to be commited - with the `--staged` flag:

```bash
$ git diff --staged
diff --git a/file1.txt b/file1.txt
index 257cc56..3bd1f0e 100644
--- a/file1.txt
+++ b/file1.txt
@@ -1 +1,2 @@
 foo
+bar
```

Now we finish up by committing the change:

```bash
$ git commit -m 'Write "bar" in file1.txt'
[main 6202970] Write "bar" in file1.txt
 1 file changed, 1 insertion(+)

$ git status
On branch main
nothing to commit, working tree clean
```

## Make another change

Now let's make one more change to practice the workflow.

Here we introduce another shortcut: we skip the add command and instead do the commit command with the `-a` option (combined with the `m` into `-am`) to automatically stage all changes before committing. This is good if you have made small changes that you want to commit quickly, but be careful so that you know what has changed in the working directory before you use it.

```bash
$ echo "baz" >> file1.txt
$ git status
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   file1.txt

no changes added to commit (use "git add" and/or "git commit -a")

$ git commit -am 'Write "baz" in file1.txt'
[main 9f7578f] Write "baz" in file1.txt
 1 file changed, 1 insertion(+)

$ git status
On branch main
nothing to commit, working tree clean
```

## View history

Now that we have made a few commits, we can take a look at the history. In Git, this is called the "log" and we use the `git log` command to view it:

```bash
$ git log
commit 9f7578f5bb7b9ac72b59439962d29afefaf072b8 (HEAD -> main)
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:50:39 2023 +0200

    Write "baz" in file1.txt

commit 62029704138584bb1aa799a23be37a156d534dd7
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:49:58 2023 +0200

    Write "bar" in file1.txt

commit 659ccda465437eb7d3213a5e24b411a8722ec7d4
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:40:28 2023 +0200

    Add file1.txt
```

As you can see, this displays each commit we have made so far. 

Every commit has a unique identifier which is a sha1 checksum. This is called the "commit sha" or "commit hash".

The commit hash is calculated based on the file contents (i.e. what is in all files that are being commited), and the commit author, creation date and sha1 checksums of parent commits. Therefore they will be unique depending on what, who, when and where (in the commit tree). This means that the commit hashes on your computer will be different compared to the examples here!

Also note that the first commit in the list (which is the last commit made) is marked as the HEAD. This is the commit currently checked out in your working directory.

The log command has many options for selecting what to include and format the output. Some useful examples are:

```bash
# You can limit the number of commits to show with '-n':
$ git log -n 2
commit 9f7578f5bb7b9ac72b59439962d29afefaf072b8 (HEAD -> main)
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:50:39 2023 +0200

    Write "baz" in file1.txt

commit 62029704138584bb1aa799a23be37a156d534dd7
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:49:58 2023 +0200

    Write "bar" in file1.txt

# There are a number of predefined formats you can use, like 'oneline':
$ git log --oneline
9f7578f (HEAD -> main) Write "baz" in file1.txt
6202970 Write "bar" in file1.txt
659ccda Add file1.txt

# You can also supply a formatting string:
$ git log --pretty=format:"%h - %s%nby %an %ar%n"
9f7578f - Write "baz" in file1.txt
by Anders Sigfridsson 5 minutes ago

6202970 - Write "bar" in file1.txt
by Anders Sigfridsson 5 minutes ago

659ccda - Add file1.txt
by Anders Sigfridsson 15 minutes ago
```

## See what changed

At this point, let's take a look at the contents of `file1.txt` in the working directory:

```bash
# The 'cat' command prints the contents of a file
$ cat file1.txt
foo
bar
baz
```

Since there are no changes (check with `git status`), this is `file1.txt` as it is in the commit currently checked out into the working directory, i.e. the HEAD.

Now since Git has tracked the changes to the file, we can also see how it has changed over time.

First, let's see what the latest change was with the git show command. This shows us details of the commit (the sha1, the author, the date and the commit message) and the difference compared to the parent commit.

```bash
$ git show
commit 9f7578f5bb7b9ac72b59439962d29afefaf072b8 (HEAD -> main)
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:50:39 2023 +0200

    Write "baz" in file1.txt

diff --git a/file1.txt b/file1.txt
index 3bd1f0e..86e041d 100644
--- a/file1.txt
+++ b/file1.txt
@@ -1,2 +1,3 @@
 foo
 bar
+baz
```

You can also see the difference between any two commits using the `git diff` command. We used this earlier to see what had changed in the working directory, but if you specify two commit hashes it will show you the difference between them instead. For example, let's say we want to see what changed between the first and second commits in the log.

(Remember that the commit hashes will be different in your repository!)

```bash
$ git log --oneline
9f7578f (HEAD -> main) Write "baz" in file1.txt
6202970 Write "bar" in file1.txt
659ccda Add file1.txt

# Note that we specify the earlier commit 
# (the ancestor) as the FIRST argument here:
$ git diff 659ccda 6202970
diff --git a/file1.txt b/file1.txt
index 257cc56..3bd1f0e 100644
--- a/file1.txt
+++ b/file1.txt
@@ -1 +1,2 @@
 foo
+bar
```

Another thing to note here is that we only specified short commit hashes. Usually you only have to specify the 7 to 10 first characters from a commit hash for Git to be able to identify it.

The diff command displays the difference between any two commits. In the example above, the first commit was the parent of the second commit. However, you can also specify commits that are not immediately following each other to see all changes made between them. For example, we can display the difference between the first and the third commit, which includes the change made in commit 2:

```bash
$ git diff 659ccda 9f7578f
diff --git a/file1.txt b/file1.txt
index 257cc56..86e041d 100644
--- a/file1.txt
+++ b/file1.txt
@@ -1 +1,3 @@
 foo
+bar
+baz
```

(Actually, since commits are snapshots of all files in the repository, you can diff commits that are not related at all.)

## Checkout another version

Lastly, let's say that we want to get an older version of our file back. To do this, we can checkout an earlier commit and Git will replace the files in your working directory with those in that commit:

```bash
$ git checkout 6202970
Note: switching to '6202970'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 6202970 Write "bar" in file1.txt
```

Whenever you checkout a specific commit (instead of a branch or a tag), Git will tell you that you are in "detached HEAD state". This is because the commit that your HEAD points to is not pointed to by any reference, so changes you make here can easily be lost if you then checkout another commit.

Ignoring that, we can see that the contents of the file is now as it was in commit 2:

```bash
$ cat file1.txt
foo
bar
```

Using the `git log` command now only shows you the first 2 commits we made:

```bash
$ git log
commit 62029704138584bb1aa799a23be37a156d534dd7 (HEAD)
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:49:58 2023 +0200

    Write "bar" in file1.txt

commit 659ccda465437eb7d3213a5e24b411a8722ec7d4
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:40:28 2023 +0200

    Add file1.txt
```

Let's finish up by returning to our latest commit.

```bash
$ git checkout 9f7578f
Previous HEAD position was 6202970 Write "bar" in file1.txt
HEAD is now at 9f7578f Write "baz" in file1.txt
$ git status
HEAD detached at 9f7578f
nothing to commit, working tree clean
$ git log
commit 9f7578f5bb7b9ac72b59439962d29afefaf072b8 (HEAD, main)
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:50:39 2023 +0200

    Write "baz" in file1.txt

commit 62029704138584bb1aa799a23be37a156d534dd7
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:49:58 2023 +0200

    Write "bar" in file1.txt

commit 659ccda465437eb7d3213a5e24b411a8722ec7d4
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:40:28 2023 +0200

    Add file1.txt
```

Ok, so we are back on the last commit we made and everything looks OK. But why is Git still saying that we are in detached HEAD state?

This is because we still checkedout a specific commit sha and thus this is what the HEAD currently points to. But this still means that if we make changes here and then checkout another commit, we have no way of returning to our changes except remembering what commit hashes we have created and typing them in again.

However, if we instead use a branch name - a reference - when we checkout, Git will now that we want this named reference to be updated - moved - whenever we make a new commit. Therefore we can always return to that place in the commit tree by providing the name of the reference.

Right now, we have the default "main" branch that we can use:

```bash
$ git checkout main
Switched to branch 'main'
$ git log
commit 9f7578f5bb7b9ac72b59439962d29afefaf072b8 (HEAD -> main)
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:50:39 2023 +0200

    Write "baz" in file1.txt

commit 62029704138584bb1aa799a23be37a156d534dd7
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:49:58 2023 +0200

    Write "bar" in file1.txt

commit 659ccda465437eb7d3213a5e24b411a8722ec7d4
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Thu Sep 28 12:40:28 2023 +0200

    Add file1.txt
```

Notice that on the top commit HEAD is pointing to main (which is pointing to 9f7578f).

This brings ut nicely on to the topic of branches, which is what the next sections will be about!
