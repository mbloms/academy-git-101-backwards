# Undoing things - unmodify, unstage, amend, reset and revert

# Prerequisites

This excercise assumes the following:

- You have installed Git (see https://git-scm.com/downloads for instructions)
- You run the commands in a Bash shell terminal (on Windows, use Git Bash or equivalent)
- You have configured Git with your name and email with the following commands:

      git config --global user.name "Your Name"
      git config --global user.email "your.name@omegapoint.se"

- You have a Github account that is connected to the Omegapoint organization (see the "Remote repositories" part of the course for instructions)

# Instructions

This exercise is designed for you to follow along. There will be short texts describing and explaining what should be done followed by code blocks with the commands to run. 

You should place these instructions in one window and have a terminal window open beside it so that you can type the commands.

In the code blocks, every line starting with a $ sign is a command to run (you skip the $ sign itself!). Every line starting with a # sign is a comment that explains or give some more detail about the following command. All other lines are output 

Most of the steps assume that you have run every step up to that point, so make sure you run every command in the correct order or that your Git repository is in an equivalent state.

# Excercises

## Clone the shared repository

You will perform these exercises in the course lab repository, so begin by making sure that you have cloned it and that you have checked out the main branch. Your working directory should be clean (no changed files) and there should be no changes staged.

## Restore file in working directory (unmodify)

Begin by making a change to a file:

```bash
$ echo "Foo" >> README.md
$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

This change was no good, so we want to undo it. Use the Git restore command:

```bash
# The -- before the filename below is just a way of separating the command from the path specs. You can leave it out if you want, but it is goot practice to use it.
$ git restore -- README.md
$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

What you have effectively done is to checkout the file from the current HEAD commit, typically the last commit on the branch you are currently working on.

You specified a single file here, but if you want to restore all changed files, you can do this: `git restore .`.

## Restore file from index (unstage)

Now let's say that we staged the change before we changed our minds:

```bash
$ echo "Foo" >> README.md
$ git add README.md
$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   README.md
```

By default, the command restores files in the working directory, but you can add the `--staged` flag to restore staged files:

```bash
$ git restore --staged -- README.md
$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

Note that the change is no longer staged, but it is still there in your working directory. What happened is that you unstaged it, so it will not be included in the next commit, but Git did not throw away your work. It just assumes you did not want to commit it yet. If you want to throw it away, you have to restore the file in the working directory as well, just as you did in the first stage of these exercises.

## Edit a commit (amend)

Another scenario is that you have made a commit that is not yet pushed to a shared repository and discover something that you want to change in it. Assuming that you have not already checked out another branch or made more commits, you can edit the files in your working directory, stage them and then make a commit with the `--amend` flag. Instead of creating a new commit, Git will integrate your changes with the latest commit and let you edit the commit message. The end result is a new commit that replaces the old one.

Let's try it! Add the following line below `parser = ArgumentParser...` in the main function function in `calc.py`: 

```python
parser.add_argument('-d', '--debug', action='store_true', help='Run in debug mode')
```

The diff should look something like this:

```bash
$ git diff
diff --git a/calc.py b/calc.py
index ef08ebf..ea697ea 100755
--- a/calc.py
+++ b/calc.py
@@ -36,6 +36,8 @@ def main():

     parser = argparse.ArgumentParser(description="A simple calculator with add and multiply commands.")

+    parser.add_argument('-d', '--debug', action='store_true', help='Run in debug mode')
+
     subparsers = parser.add_subparsers()

     add_parser = subparsers.add_parser('add', help='Adds the provided numbers.')
```

Now commit the change. You can use any commit message you want.

Oops! We added a command line argument, but we forgot to actually use it.

Let's fix it. Add the following below `args = parser.parse_args()` in `calc.py`:

```python
if args.debug:
    print(f'[DEBUG] Will execute: {args.func}')
```

The diff should look something like this:

```bash
$ git diff
diff --git a/calc.py b/calc.py
index ea697ea..ac97375 100755
--- a/calc.py
+++ b/calc.py
@@ -58,6 +58,8 @@ def main():

     args = parser.parse_args()
     if hasattr(args, 'func'):
+        if args.debug:
+            print(f'[DEBUG] Will execute: {args.func}')
         result = args.func(args.numbers)
         print(result)
     else:
```

Now, let's amend the previous commit:

```bash
$ git commit --amend
```

A default editor will open. Unless you have changed it, this will be Vim and it should look something like this:

```vim
Add --debug argument

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Wed Oct 11 12:17:52 2023 +0200
#
# On branch main
# Your branch is ahead of 'origin/main' by 1 commit.
#   (use "git push" to publish your local commits)
#
# Changes to be committed:
#   modified:   calc.py
```

Regardless of editor, we will leave the commit message as is and just save the file to continue. With Vim you do this by typing `Shift + :` followed by `wq` and `Enter`.

The output should be something like:

```bash
$ git commit --amend
[main fb4d37f] Add --debug argument
 Date: Wed Oct 11 12:17:52 2023 +0200
 1 file changed, 4 insertions(+)
```

And if you check the diff of the commit you can see both changes in it:

```bash
$ git show
commit fb4d37f758f9650205f00ae4e195ec95ca3f687d (HEAD -> main)
Author: Anders Sigfridsson <anders.sigfridsson@omegapoint.se>
Date:   Wed Oct 11 12:17:52 2023 +0200

    Add --debug argument

diff --git a/calc.py b/calc.py
index ef08ebf..ac97375 100755
--- a/calc.py
+++ b/calc.py
@@ -36,6 +36,8 @@ def main():

     parser = argparse.ArgumentParser(description="A simple calculator with add and multiply commands.")

+    parser.add_argument('-d', '--debug', action='store_true', help='Run in debug mode')
+
     subparsers = parser.add_subparsers()

     add_parser = subparsers.add_parser('add', help='Adds the provided numbers.')
@@ -56,6 +58,8 @@ def main():

     args = parser.parse_args()
     if hasattr(args, 'func'):
+        if args.debug:
+            print(f'[DEBUG] Will execute: {args.func}')
         result = args.func(args.numbers)
         print(result)
     else:
```

In this case we left the commit message as it was, but changing the message is actually a common usecase for amend. If you have made a commit but made a mistake or forgot something in the message, use `git commit --amend` without editing the files.

## Drop a commit (reset)

## Revert a change
