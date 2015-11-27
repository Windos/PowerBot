function new-user
{
    param ($user)

    [Viewer]::new($user)
}