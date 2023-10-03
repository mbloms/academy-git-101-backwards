# Prerequisites

Please make sure that you have done the following:

- Create a Github account
- Connect Github account to Omegapoint organization
- Create SSH keypair (see "Authentication with SSH" for instructions)
- Add SSH public key to Github account (see "Authentication with SSH" for instructions)

You should also have completed the preparation task to get the URL for the lab repository on the LMS page.

# Instructions

This exercise is designed for you to follow along. There will be short texts describing and explaining what should be done followed by code blocks with the commands to run. 

You should place these instructions in one window and have a terminal window open beside it so that you can type the commands.

In the code blocks, every line starting with a $ sign is a command to run (you skip the $ sign itself!). Every line starting with a # sign is a comment that explains or give some more detail about the following command. All other lines are output 

Most of the steps assume that you have run every step up to that point, so make sure you run every command in the correct order or that your Git repository is in an equivalent state.

# Excercises

## Clone a repository from Github

Here we assume that you have gotten the URL to a remote repository as described on the LMS page.

Once you have it, go to a directory where you want to store your projects. (I personally like to have a directory in my users home folder called "Projects", but you can place it whereever you want.)

In that directory, clone the repository with:

```bash
$ git clone git@github.com:Omegapoint/academy-git-101-lab.git
Cloning into 'academy-git-101-lab'...
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 23 (delta 11), reused 22 (delta 10), pack-reused 0
Receiving objects: 100% (23/23), done.
Resolving deltas: 100% (11/11), done.
```

You should now have another directory called "academy-git-101-lab". This is your working directory! It will contain the files of the latest commit on the default branch. This is "main" by default, but can typically be configured on the Git hosting service project page.

Git creates a directory with the same name as the repository by default, but the name of the root directory doesn't matter at all for Git. You can clone the repository into any directory you want by just adding it to the clone command: `git clone git@github.com:Omegapoint/academy-git-101-lab.git foobar`.

## Explore the repository

Now go into the directory with `cd academy-git-101-lab`.

You can see the files of the latest commit on the main branch:

```bash
$ ls
calc.py*      test_calc.py*
```

You can also see that it has a remote with the URL you specified in the clone command:

```bash
$ git remote -v
origin	git@github.com:Omegapoint/academy-git-101-lab.git (fetch)
origin	git@github.com:Omegapoint/academy-git-101-lab.git (push)
```

If you check what branches there are, you will only see "main" and that it is currently checkedout:

```bash
$ git branch
* main
```

However, there are more branches in the remote repository. Remember that Git creates remote references to keep track of these. You can check what branches exist with:

```bash
$ git branch -a
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/add-exponentiation
  remotes/origin/main
  remotes/origin/refactor
```

Depending on when you take this course the actual branches here may vary, but the ones you see above should be there at least. You can see that one branch - "main" - exists as both a local branch (called just "main") and a remote branch (called "remotes/origin/main"). The other branches prefixed with "remotes/origin" are branches that you have not yet checked out.

Let's try checking out one of them, the "add-exponentiation" branch:

```bash
$ git switch add-exponentiation
branch 'add-exponentiation' set up to track 'origin/add-exponentiation'.
Switched to a new branch 'add-exponentiation'
```

Note that you did not have to specify "remotes/origin" there. Git will check for local branches first and if it does not find one, it will check for remote branches with the same name.

Now check branches again:

```bash
$ git branch -a
* add-exponentiation
  main
  remotes/origin/HEAD -> origin/main
  remotes/origin/add-exponentiation
  remotes/origin/main
  remotes/origin/refactor
```

You can see that the remote branches are unchanged, but you now have a new local branch called "add-exponentiation".

## Make a change

When you work on a local branch it will begin to diverge from the remote branch. Git keeps track of where the local branch is in relation to the remote branch. The remote branch is referred to as the "upstream" and you say that your branch "tracks the upstream branch". You can see this with the status command:

```bash
$ git status
On branch add-exponentiation
Your branch is up to date with 'origin/add-exponentiation'.

nothing to commit, working tree clean
```

Note that the output above says that your branch is "up to date" with the remote branch.

Now let's make a commit on this branch:

```bash
$ echo "# comment" >> calc.py
$ git commit -am 'Add comment'
[add-exponentiation b0c8ff6] Add comment
 1 file changed, 1 insertion(+)
$ git status
On branch add-exponentiation
Your branch is ahead of 'origin/add-exponentiation' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
```

Now the Git status command says that your branch is "ahead" by 1 commit, meaning that you have one commit on the "add-exponention" branch that does not exist on "add-exponentiation" on the remote.

You can see this if you check the log:

```bash
$ git log --oneline --graph --all
* b0c8ff6 (HEAD -> add-exponentiation) Add comment
* b1ad930 (origin/add-exponentiation) Add expo function and failing tests
| * 4df3d6d (origin/refactor) Refactor print statement
| * ed44c29 (origin/main, origin/HEAD, main) Add README file
|/
* fd41b49 Add subtract function
* 70de91d Add division function
* b09a926 Add calc.py
```

Of course, this is as far as you know! Other commits may have been made in the remote repository while you were working, but the information in your repository is only updated when you fetch changes from the remote. Let's explore this!

## Fetch changes

Before we continue you have to get another clone of the remote repository. Just run the clone command again but this time specify 