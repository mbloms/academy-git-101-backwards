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

Now list branches again:

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

When you work on a local branch it will diverge from the remote branch. Git keeps track of where the local branch is in relation to the remote branch. The remote branch is referred to as the "upstream" and you say that your branch "tracks the upstream branch". You can see this with the status command:

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

Note that the Git status command says that your branch is "ahead" by 1 commit, meaning that you have one commit on the "add-exponention" branch that does not exist on "add-exponentiation" on the remote.

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

## Create another clone

Before we continue you have to get another clone of the remote repository. It is recommended that you open another terminal window and work on the other clone there. To facilitate this, we will call the terminal window you have worked in so far "terminal 1" and the new terminal window "terminal 2".

So, in terminal 2, go to your project dir and run the clone command again, but this time specify a custom dirname:

```bash
git clone git@github.com:Omegapoint/academy-git-101-lab.git another-clone
Cloning into 'another-clone'...
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 23 (delta 11), reused 22 (delta 10), pack-reused 0
Receiving objects: 100% (23/23), done.
Resolving deltas: 100% (11/11), done.
```

Go into the directory "another-clone" and check what branches are there (use the same commands as in the previous examples).

## Push a new branch (terminal 1)

Now go back to terminal 1 and the original clone. Create a new branch from the main branch and switch to it. We'll call it "username-remote-lab" in the following examples, but you need to give it a unique name, so use your own name or some other identifier. We leave the exact steps up to you. Make sure you have checked out the new branch when you are finished! You can refer back to the previous exercises or ask for help if you do not remember how.

Now if you check your branches again, you will see that there is a local branch called "username-remote-lab", but no remote counterpart:

```bash
$ git branch -a
  add-exponentiation
  main
* username-remote-lab
  remotes/origin/HEAD -> origin/main
  remotes/origin/add-exponentiation
  remotes/origin/main
  remotes/origin/refactor
```

Let's push the new branch to the remote repository. We'll use the `git push` command with a few arguments: 

- The first argument is the name of the remote that you want to push to. It's "origin" here and often is, but can be anything. 
- The second argument is what you want to push. It's typically the name of a branch that you are working on, but can be any reference. (You can also specify what remote reference you want to push to, but this is a more advanced usecase that we will not delve into here.) 
- Lastly, we add the `-u` flag, which means that we want Git to track the upstream branch (as we mentioned above when you checked out a remote branch).

```bash
$ git push origin username-remote-lab -u
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote:
remote: Create a pull request for 'username-remote-lab' on GitHub by visiting:
remote:      https://github.com/Omegapoint/academy-git-101-lab/pull/new/username-remote-lab
remote:
To github.com:Omegapoint/academy-git-101-lab.git
 * [new branch]      username-remote-lab -> username-remote-lab
branch 'username-remote-lab' set up to track 'origin/username-remote-lab'
```

You have created a new branch in the shared repository! If you check your branches again you should see `remotes/origin/username-remote-lab`. 

In the output here you also see some messages from the remote, those lines beginning with "remote:". What this says varies depending on the Git hosting service. For Github, it informs you what you can create a pull request, but it can be anything or nothing.

If you forgot to add `-u` when you pushed, you can do this afterwards as well with:

```bash
$ git branch --set-upstream-to origin/username-remote-lab
branch 'username-remote-lab' set up to track 'origin/username-remote-lab'.
```

## Fetch new branch (terminal 2)

Back to terminal 2 and your other clone. We'll use the `git fetch` command to fetch new changes:

```bash
$ git fetch
From github.com:Omegapoint/academy-git-101-lab
 * [new branch]      username-remote-lab -> origin/username-remote-lab
```

You should see that the branch you pushed from the other repository has been fetched. Switch to it and check what commits are on it (again, we leave these steps up to you).

## Push a new commit (terminal 1)

Now go back to the original clone in terminal 1 and make a commit on "username-remote-lab". You can change any file you want, it doesn't matter. Give it an approrpate commit message, something that describes what has been changed.

Once you have done that, do another push. Make sure you have checked out "username-remote-lab"! Since the branch is setup to track the upstream branch, you can leave out the arguments to the command this time:

```bash
$ git push
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 10 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 378 bytes | 378.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:Omegapoint/academy-git-101-lab.git
   ed44c29..b58e269  username-remote-lab -> username-remote-lab
```

## Pull new commits (terminal 2)

In terminal 2, you will not yet see the new commit you made (check with the `git log` command). Ok, so let's fetch the new changes. Make sure you have checked out the branch called "username-remote-lab" and then do this:

```bash
$ git fetch
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 1), reused 3 (delta 1), pack-reused 0
Unpacking objects: 100% (3/3), 358 bytes | 179.00 KiB/s, done.
From github.com:Omegapoint/academy-git-101-lab
   ed44c29..b58e269  username-remote-lab -> origin/username-remote-lab
$ git log --oneline
ed44c29 (HEAD -> username-remote-lab, origin/main, origin/HEAD, main) Add README file
fd41b49 Add subtract function
70de91d Add division function
b09a926 Add calc.py
```

You can see from the fetch command output that a new commit was fetched, but when you check your log you will not see it. What gives?!

This is because the fetch command does not automatically update your local branch. It will just fetch new changes and update the remote reference, which in this case is `remotes/origin/username-remote-lab`. You can see it if you check status:

```bash
$ git status
On branch username-remote-lab
Your branch is behind 'origin/username-remote-lab' by 1 commit, and can be fast-forwarded.
  (use "git pull" to update your local branch)

nothing to commit, working tree clean
```

Git does this because you might have made other changes on the local branch that might conflict with the changes in the remote branch (we'll come back to the topic of resolving conflicts in a later section of this course). However, in this case there are no conflicts and you local branch can just be moved ahead to the same commit as the remote branch, which is what "can be fast-forwarded" in the above output means. To do this, use the `git pull` command:

```bash
$ git pull
Updating ed44c29..d97f6d6
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)
$ git status
On branch username-remote-lab
Your branch is up to date with 'origin/username-remote-lab'.

nothing to commit, working tree clean
```

Now you are up to date with the latest changes from the remote repository!
