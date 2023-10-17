# Collaboration - merge, rebase and resolve conflicts

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

# Exercises

## Clone the shared repository

You will perform these exercises in the course lab repository, so begin by making sure that you have cloned it and that you have checked out the main branch. Your working directory should be clean (no changed files) and there should be no changes staged.

If you do have changes in the cloned repository, please make another clone so that your starting point is clean.

## Merge two branches

In this exercise, you will merge `exercise-merge-1` into `exercise-merge-2`. You should have these two branches in your repository clone:

```bash
$ git log --oneline --graph origin/exercise-merge-1 origin/exercise-merge-2
* c0d733a (origin/exercise-merge-1) Print function on debug
* 02dcc90 Add debug argument
| * ed44c29 (origin/exercise-merge-2) Add README file
| * fd41b49 Add subtract function
|/
* 70de91d Add division function
* b09a926 Add calc.py
```

As you can see, `origin/exercise-merge-1` is based on an earlier commit and has two commits that are not in `origin/exercise-merge-2`. To merge them, switch to `origin/exercise-merge-2` and use the `git merge` command:

```bash
$ git checkout exercise-merge-2
branch 'exercise-merge-2' set up to track 'origin/exercise-merge-2'.
Switched to a new branch 'exercise-merge-2'
# Notice how the branch exercise-merge-2 was created and set to track
# origin/exercise-merge-2 (i.e. the remote branch) when you checked it out

# An editor will open after the following command. If it is
# Vim (the default), write : followed by wq and Enter.
$ git merge origin/exercise-merge-1
Auto-merging calc.py
Merge made by the 'ort' strategy.
 calc.py | 4 ++++
 1 file changed, 4 insertions(+)
```

You have now merged the two branches:

```bash
$ git log --oneline --graph origin/exercise-merge-1 exercise-merge-2
*   cd90fbf (HEAD -> exercise-merge-2) Merge remote-tracking branch 'origin/exercise-merge-1' into exercise-merge-2
|\
| * c0d733a (origin/exercise-merge-1) Print function on debug
| * 02dcc90 Add debug argument
* | ed44c29 (origin/exercise-merge-2) Add README file
* | fd41b49 Add subtract function
|/
* 70de91d Add division function
* b09a926 Add calc.py
```

## Rebase a branch

In this exercise you want to update a `exercise-rebase` with the latest changes from `main`. Put another way, you want to move the commits in `exercise-rebase` on top of `main`.

You can see that the branch is behind `main` to begin with:

```bash
$ git log --oneline --graph main origin/exercise-rebase
* 50ab9c7 (origin/exercise-rebase) Add square root function
| * ed44c29 (HEAD -> main, origin/main, origin/exercise-merge-2, origin/HEAD) Add README file
|/
* fd41b49 Add subtract function
* 70de91d Add division function
* b09a926 Add calc.py
```

To rebase a branch, being by switching to it and then use the `git rebase` command:

```bash
$ git switch exercise-rebase
branch 'exercise-rebase' set up to track 'origin/exercise-rebase'.
Switched to a new branch 'exercise-rebase'
$ git rebase origin/main
Successfully rebased and updated refs/heads/exercise-rebase.
```

If you check the log again, you will see that `exercise-rebase` now begins on `main`:

```bash
$ git log --oneline --graph main exercise-rebase
* d4e0df7 (HEAD -> exercise-rebase) Add square root function
* ed44c29 (origin/main, origin/exercise-merge-2, origin/HEAD, main) Add README file
* fd41b49 Add subtract function
* 70de91d Add division function
* b09a926 Add calc.py
```

## Resolve a conflicts

Lastly, we shall resolve a conflict. There is a branch called `exercise-conflict` that has a conflicting change with `main`, so both a rebase and a merge will fail.

Let's try a rebase:

```bash
$ git switch exercise-conflict
branch 'exercise-conflict' set up to track 'origin/exercise-conflict'.
Switched to a new branch 'exercise-conflict'
$ git rebase origin/main
Auto-merging calc.py
CONFLICT (content): Merge conflict in calc.py
Auto-merging test_calc.py
error: could not apply dc06e26... Add square function
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply dc06e26... Add square function
```

If you check the status, you will see that Git has stopped during the rebase and is waiting for input:

```bash
$ git status
interactive rebase in progress; onto ed44c29
Last command done (1 command done):
   pick dc06e26 Add square function
No commands remaining.
You are currently rebasing branch 'exercise-conflict' on 'ed44c29'.
  (fix conflicts and then run "git rebase --continue")
  (use "git rebase --skip" to skip this patch)
  (use "git rebase --abort" to check out the original branch)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   test_calc.py

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
	both modified:   calc.py
```

In the files, the conflicting rows have been highlighted:

```bash
$ git diff
diff --cc calc.py
index ef08ebf,da1aecb..0000000
--- a/calc.py
+++ b/calc.py
@@@ -25,11 -25,8 +25,16 @@@ def divide(numbers)
      return numbers[0] / numbers[1]


++<<<<<<< HEAD
 +def subtract(numbers):
 +    result = numbers[0]
 +    for n in numbers[1:]:
 +        result -= n
 +    return result
++=======
+ def square(numbers):
+     return numbers[0]**2
++>>>>>>> dc06e26 (Add square function)


  def main():
@@@ -50,9 -47,9 +55,15 @@@
      divide_parser.add_argument('numbers', type=float, nargs=2, help='The numbers to divide, given as two numbers where the first is divided by the second.')
      divide_parser.set_defaults(func=divide)

++<<<<<<< HEAD
 +    subtract_parser = subparsers.add_parser('subtract', help='Subtracts the provided numbers from the first number.')
 +    subtract_parser.add_argument('numbers', type=int, nargs='+', help='The numbers to subtract, starting from the first number.')
 +    subtract_parser.set_defaults(func=subtract)
++=======
+     divide_parser = subparsers.add_parser('square', help='Squares the given number')
+     divide_parser.add_argument('numbers', type=float, nargs=1, help='The number to square.')
+     divide_parser.set_defaults(func=square)
++>>>>>>> dc06e26 (Add square function)

      args = parser.parse_args()
      if hasattr(args, 'func'):
```

The lines below `<<<<<<< HEAD` are what those lines look like on `main` (refered to as "theirs", which is the branch you are rebasing onto), while those above `>>>>>>> dc06e26 (Add square function)` are those on the current branch (called "ours").

To resolve the conflict, edit these lines anyway you want (keeping one or the other set, keeping both, or writing some combination of them) and remove the marker lines. For example, in this case you might want to just keep both changes since they are unrelated (they just happen to be on the same lines):

```bash
$ git diff
diff --cc calc.py
index ef08ebf,da1aecb..0000000
--- a/calc.py
+++ b/calc.py
@@@ -25,13 -25,10 +25,17 @@@ def divide(numbers)
      return numbers[0] / numbers[1]


+ def subtract(numbers):
+    result = numbers[0]
+    for n in numbers[1:]:
+        result -= n
+    return result
+
+
+ def square(numbers):
+     return numbers[0]**2
+
+
  def main():

      parser = argparse.ArgumentParser(description="A simple calculator with add and multiply commands.")
@@@ -50,10 -47,10 +54,14 @@@
      divide_parser.add_argument('numbers', type=float, nargs=2, help='The numbers to divide, given as two numbers where the first is divided by the second.')
      divide_parser.set_defaults(func=divide)

+    subtract_parser = subparsers.add_parser('subtract', help='Subtracts the provided numbers from the first number.')
+    subtract_parser.add_argument('numbers', type=int, nargs='+', help='The numbers to subtract, starting from the first number.')
+    subtract_parser.set_defaults(func=subtract)
+
+     divide_parser = subparsers.add_parser('square', help='Squares the given number')
+     divide_parser.add_argument('numbers', type=float, nargs=1, help='The number to square.')
+     divide_parser.set_defaults(func=square)
+
      args = parser.parse_args()
      if hasattr(args, 'func'):
          result = args.func(args.numbers)
```

When you are done, add the file and continue the rebase:

```bash
$ git rebase --continue
[detached HEAD dfdc035] Add square function
 2 files changed, 12 insertions(+)
Successfully rebased and updated refs/heads/exercise-conflict.
```

You have resolved the conflict and the `exercise-conflict` branch is now on top of `main`:

```bash
$ git log --oneline --graph main exercise-conflict
* dfdc035 (HEAD -> exercise-conflict) Add square function
* ed44c29 (origin/main, origin/exercise-merge-2, origin/HEAD, main) Add README file
* fd41b49 Add subtract function
* 70de91d Add division function
* b09a926 Add calc.py
```

The process had been the same with a merge, except that you had done `git merge --continue` instead. Both the rebase and the merge can also be aborted with the `--aborted` flag. Git would then return your working directory to the state you started from.
