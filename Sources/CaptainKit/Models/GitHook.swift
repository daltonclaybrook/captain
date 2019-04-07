/// Available Git Hooks
///
/// Documentation at https://git-scm.com/docs/githooks
public enum GitHook: String, CaseIterable {
    case applyPatchMessage = "applypatch-msg"
    case preApplyPatch = "pre-applypatch"
    case postApplyPatch = "post-applypatch"
    case preCommit = "pre-commit"
    case prepareCommitMessage = "prepare-commit-msg"
    case commitMessage = "commit-msg"
    case postCommit = "post-commit"
    case preRebase = "pre-rebase"
    case postCheckout = "post-checkout"
    case postMerge = "post-merge"
    case prePush = "pre-push"
}
