This is a multi-part answer because there are two separate issues here that are tangling together now. Here's a summary of what we'll cover:

main vs master
error: src refspec main does not match any
reconciling separate main and master branches
Each of these is in its own section.

main vs master
Git itself has no special branch names.1 You could use main, master, trunk, or any other name as the name of your first branch. Git has traditionally used the name master here, but there is a project to make this configurable, so that if you are French or Spanish you can use the name principal or première or primero, or if you prefer Maori, you can use matua or tuatahi. Currently, you can do this manually during or after a git init,2 but the project makes Git just do it automatically, without requiring a second step: If for any reason you want any other name by default, you can configure that.

Meanwhile, GitHub have already chosen to leap ahead and make their default initial branch name main instead of master. But this leaves your Git and GitHub's Git out of sync, as it were. For more about GitHub's changeover, see Difference Between Main Branch and Master Branch in Github?

1There are some technical flaws in this kind of claim. As we know, technically correct is the best kind of correct, so let me add a few caveats in this footnote:

Merging auto-generates a message of the form merge branch X into Y when you are on branch Y and run git merge X. However, when you're on master, Git traditionally generates only a message of the form merge branch X.

A new, empty repository created by git init has no commits and therefore has no branches (because a branch can only exist by having commits on it). However, you must be on some branch in this new empty repository. So Git stores some name in the symbolic ref named HEAD. This is the branch name that you're on, even if that branch name does not exist (yet). For a long time, Git has had, hard-coded into it, some code to stick the branch name master in there. (This is, in effect, what GitHub changed.)

There are a bunch of other string literals reading master in the source and documentation as well; they're being converted to use the configuration settings but this will all take time.

2If you have Git 2.28 or later, run git init --initial-branch=name, and/or set init.defaultBranch with git config in your system or global configuration. If you have an earlier version of Git installed, or have already run git init, simply use git branch -m to rename master to whatever name you like.

error: src refspec main does not match any
This error message from Git is quite cryptic to newbies, but is actually pretty simple. The problems are that it's loaded with jargon (webster; wikipedia), and abbreviates "source" to "src".

Git is all about commits. When we clone a repository, we have our Git reach out to some other Git. That other Git looks up a repository, and that other repository is full of commits. We then have our Git create a new repository locally, transfer into it all of their commits, and turn all of their branch names into remote-tracking names. Then our Git creates, in this new repository, one branch name, based on one of their branch names. At least, that's the normal process. (And, if you know what all these terms mean, good! If not, don't worry too much about them right now. The point to remember here is that we get all their commits and none of their branches, and then we normally have our Git create one branch to match one of theirs.)

Since Git is all about commits, this process—of copying all their commits, but only copying one of their branch names to a name spelled the same in our own repository—is all we need. The fact that our Git renames all of their branch names—so that with the one exception, we don't have any branches at all—isn't normally very important. Our own Git deals with this later, automatically, if and when it's necessary.

When we use git push, we are asking our Git program, which is reading our own Git repository, to connect to some other Git program—typically running on a server machine—that can then write to some other Git repository. We'd like our Git to send their Git some of our commits. In particular, we want to send them our new commits: the ones we just made. Those are, after all, where we put all our good new stuff. (Git is all about commits, so that's the only place we can put anything.)

Once we've sent these commits, though, we need to their Git to set one of their branch names to remember our new commits. That's because the way Git finds commits is to use branch names.3 The real names of each commit are big ugly hash ID numbers, which nobody wants to remember or look at; so we have Git remember these numbers using the branch names. That way, we only have to look at the branch names, and these names can be meaningful to us: trunk, or feature/tall, or tuatahi, or whatever.

By default and convention, the way we do this using git push is pretty simple:

git push origin main
for instance. The git push part is the command that means send commits and ask them to set a name. The origin part is what Git calls a remote: a short name that, mostly, holds a URL. The main part at the end, here, is our branch name. That's the one our Git is using to find our commits. We'll have our Git send our commits, then ask their Git to set their main too.

This last part—where we've put in main here—is what Git calls a refspec. Refspecs actually let us put in two names, separated by a colon, or a couple of other forms. We can, for instance, use HEAD:main as in Arka's answer (although for technical reasons we might want to use HEAD:refs/heads/main in many cases). But in simple cases, we can just use one branch name: git push origin main. The simple branch name is a simple form of refspec.

For this to work, the source name must be the name of an existing branch in our own Git repository. This is where things are going wrong.

(See also Message 'src refspec master does not match any' when pushing commits in Git)

3Git can use any name, not just a branch name. For instance, a tag name works fine. But this answer is about branch names because the question is about branch names, and branch names are the most common ones to use here.

What if our Git created only master?
Suppose we're using GitHub and we've asked GitHub to make a new repository for us. They run a form of git init that supplies, as the new repository's initial branch name, the name main. They may or may not create one commit, too. Let's say we do have them create this one commit. That one commit will hold README and/or LICENSE files, based on what we choose using the web interface. Creating that initial commit actually creates the branch name main.

If we now clone their repository, we'll get their one commit, which will be under their branch name main. Our Git will rename their main to origin/main and then create one new branch name, main, to match theirs. So all will be good.

But, if we create our own empty Git repository, using git init ourselves, our Git may set us up so that our first commit will create the name master. We won't have a main branch: we'll have a master branch instead.

Or, if we don't have GitHub create an initial commit, the GitHub repository will be totally empty. Because it has no commits, it has no branches: a branch name is only allowed to exist if it specifies some commit. So if we clone this empty repository, we'll have no branches either, and our Git won't know to use main: our Git may instead use master. We're back in that same situation, where our Git think the first name to create should be master.

So, in these various situations, we make our first commit(s), and they all go on a branch named master
