# \[bakifrån\] Preface

This exercise has been proudly stolen and extended with extra exercises using git plumming commands.

Read more about in chapter 10 of the Git Book: [10.1 Git Internals - Plumbing and Porcelain](https://git-scm.com/book/en/v2/Git-Internals-Plumbing-and-Porcelain).

The sections not in the original exercises are prefixed with "\[bakifrån\]".

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

~This course will not go into any more details about what is in this directory and you will typically not have to look into it during everyday work, but it is important to know that this is your Git repository.~
Or will it?

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

## \[bakifrån\] View the raw git objects you just created

The plumming command `git cat-file` can be used to print a git object.

```bash
$ git cat-file -p main
tree 597d2a27b86badb763877b035d9712120d2b5858
author Mikael Blomstrand <mikael.blomstrand@omegapoint.se> 1733434795 +0100
committer Mikael Blomstrand <mikael.blomstrand@omegapoint.se> 1733434795 +0100
```

```bash
$ git cat-file -p 597d2a27b86badb763877b035d9712120d2b5858
100644 blob 257cc5642cb1a054f08cc83f2d943e56fd3ebe99    file1.txt
```

```bash
$ git cat-file -p 257cc5642cb1a054f08cc83f2d943e56fd3ebe99
foo
```

Try it out yourself!

Git objects are stored in .git/objects. They are named after the hash of the content they hold.

Use `tree` (can be installed with your favorite package manager) or `ls`to list them!

```bash
$ tree .git/objects/
.git/objects/
├── 11
│   └── 6700b54ccee9fd0ecbe22cd90cae0c83dd882f
├── 25
│   └── 7cc5642cb1a054f08cc83f2d943e56fd3ebe99
├── 59
│   └── 7d2a27b86badb763877b035d9712120d2b5858
├── info
└── pack

6 directories, 3 files
```

```bash
$ ls -1 .git/objects/*/
.git/objects/11/:
6700b54ccee9fd0ecbe22cd90cae0c83dd882f

.git/objects/25/:
7cc5642cb1a054f08cc83f2d943e56fd3ebe99

.git/objects/59/:
7d2a27b86badb763877b035d9712120d2b5858

.git/objects/info/:

.git/objects/pack/:
```

As you can see, the three objects stored under .git/objects match the commit object, the tree object, and the blob object containing foo. These files hold the compressed content of each object.

## \[bakifrån\] Make the initial commit using plumming commands

Let's redo the intial commit, but using only plumming commands this time!

Start by checking out a new _fresh_ branch by running
```bash
$ git switch --orphan main-bakifrån
Switched to a new branch 'main-bakifrån'
```

The `--orphan` flag tells git create a branch without any commits on it. Just as if it was a new repository.

You should be left with a clean and empty working directory:

```bash
git status
On branch main-bakifrån

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

```bash
$ ls
```

### Hashing the file

Blob objects (normal files) can be written using the plumming command `git hash-object`.

```bash
$ echo "foo" | git hash-object -w --stdin
```

> What's `-w` and `--stdin`? `-w` tells git to write the object to the object database (the .git/objects directory). `--stdin` tells git to read from input instead of from a file. If you wanted to hash a file you could instead run `git hash-object -w foobar.txt`.

### Add the file to the index

Use the plumming command `git update-index` to add the hashed blob to the index. Since the blob object only holds the content, we have to also supply the name (file1.txt) and the [file mode](https://www.tutorialspoint.com/unix/unix-file-permission.htm) (100644).

```bash
$ git update-index --add --cacheinfo 100644 257cc5642cb1a054f08cc83f2d943e56fd3ebe99 file1.txt
```

Note that your working directory is still empty.

But if you run `git status` now, the file shows up as staged to be added, because we added it to the index. And it shows up as deleted in the working directory.

```bash
$ git status
On branch main-bakifrån

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
    new file:   file1.txt

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
    deleted:    file1.txt
```

The reason why git says the file has been deleted is because it tracks the "unstaged" changes as the difference between the working directory and the index. Git sees the file in the index but not in the working directory and draws the conclusion that it has been deleted.

### Hash the tree

Now that we have staged the file, we can hash and write the tree.

```bash
$ git write-tree
597d2a27b86badb763877b035d9712120d2b5858
```

### Make the commmit

Finally make the inital commit consisting of the tree we just hashed.

```bash
$ git commit-tree 597d2a27b86badb763877b035d9712120d2b5858 -m "Add file1.txt"
7ead3a7a49ae5bf8d4a55f76e4c57cb91fa986e3
```

### Point the branch to the commit

Now that you have created the commit object. You could use `git reset` to make the current branch point to it.

```bash
$ git reset 7ead3a7a49ae5bf8d4a55f76e4c57cb91fa986e3
Unstaged changes after reset:
D   file1.txt
```

> Alternatively you can manually write the commit to the git ref
> ```bash
> $ echo 7ead3a7a49ae5bf8d4a55f76e4c57cb91fa986e3 > .git/refs/heads/main-bakifrån
> ```

Note that the working directory is still empty! And the file show up as deleted in `git status`. You can make the working directory match the index by running:

```bash
$ git checkout -- .
```
Where `--` refers to the index and `.` is the current directory (and all files in it)

Or by simply doing a HARD reset:

```
git reset --hard 7ead3a7a49ae5bf8d4a55f76e4c57cb91fa986e3
```

Now if you look at what has been created in the .git/objects directory, there actually is only one new object, the new commit. Why? Because both the content of the blob object (file1.txt) and the tree-object (the actual folder) is identical to what we committed before. (The timestamp is different in the commit objects.)
Git only stores every identical object once, which is why even if you have a million commits, git doesn't need to store a million copies of every file. Neat huh?

## \[bakifrån\] Change a file

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

Stage the file!

__\[bakifrån\]__ You could add this file (stage) to the index using `git add`. You could also manually hash it the same way we did before. A shortcut would be to use `git update-index file1.txt`.

_Tip: If you want to try something new. Try running `git add -p`._

```bash
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   file1.txt
```

Again hash the tree using `git write-tree`.

```bash
$ git write-tree
597d2a27b86badb763877b035d9712120d2b5858
```

Try making a commit the same way as before, but with the new tree and the message 'Write "bar" in file1.txt'.

```bash
$git commit-tree 398eb7437b7f5553facd0bdf0759ce6683d8f17f -m 'Write "bar" in file1.txt'
e54d4526d87c904edbb752b40df3b4538dbb891e
```

You can also use `git show` followed by the commit hash to show what changed in the commit.

It says the whole file file1.txt was added! That's not right.

We can look at the history using `git log` followed by the commit hash.

```bash
$ git log e54d4526d87c904edbb752b40df3b4538dbb891e
commit e54d4526d87c904edbb752b40df3b4538dbb891e
Author: Mikael Blomstrand <mikael.blomstrand@omegapoint.se>
Date:   Fri Dec 6 01:01:39 2024 +0100

    Write "bar" in file1.txt
```

Only the latest commit gets printed. What about the previous commits?

We forgot to name a parent for the commit.

```bash
$ git commit-tree 398eb7437b7f5553facd0bdf0759ce6683d8f17f -p 7ead3a7a49ae5bf8d4a55f76e4c57cb91fa986e3 -m 'Write "bar" in file1.txt'
6c27fcc2287f7d59c9c5c9ce62fc7cb0552ea530
```

Now how does it look whe you run `git show`?

Print the commit object we just committed using `git cat-file -p`. Compare it to the commit object without a parent.

<details>
  <summary>What's the difference?</summary>
  There's a parent, and the timestamps are different.
</details>

This says a lot about how git tracks content and changes. In fact, git actually doesn't track changes at all! It tracks the sate of the repository in every commit and calculates changes by comparing the contents of commits with each other.

## \[bakifrån\] Manually making a merge commit

The previous commit we made included a single parent. `git commit-tree` can take multiple `-p` parents as argument. Doing so will create a commit with multiple parents: a merge commit! There is no theoretical limit on how many parents a commit can have.

Make the index match the first commit that we created. Make a change, e.g. e.g. by adding a file and make a commit with that change. Don't change the file1.txt file.

Now take use `git cat-file -p` to show the new commit and the commit from the previous step with the message 'Write "bar" in file1.txt'.
Use it again on the tree hashes.

Use the commands you have seen here to make a tree-object containing both the newest version of file1.txt, and whatever you added in your new commit.

Take this tree hash and generate a merge commit using
```bash
$ git commit-tree <tree> -p <'Write "bar" in file1.txt'> -p <new commit> -m "Merge manually"
```

How does it look in a git GUI? How does it compare to a merge commit made in the "normal" way? Experiment with even more parents!
