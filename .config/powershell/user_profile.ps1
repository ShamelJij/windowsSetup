set-alias .. cd..
set-alias dd cd
set-alias sss ex
set-alias cll cls
set-alias ll ls
set-alias grep findstr
set-alias g git

$start = $env:myStart

Import-Module posh-git
Import-Module Terminal-Icons
Import-Module PSReadLine

function gopro{nvim $env::myStart\.config\powershell\user_profile.ps1}
function Write-BranchName () {
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host "$branch" -ForegroundColor "red"
        }
        else {
            # we're on an actual branch, so print it
            Write-Host "$branch" -ForegroundColor "cyan"
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host "no branches yet" -ForegroundColor "yellow"
    }
}

function prompt {

    #Assing Branchname from the fucntion
    $branchName = Write-BranchName

    #Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "Current Folder: $pwd"

    #Configure current user, current folder and date outputs
    $CmdPromptCurrentFolder = Resolve-Path .
    $Date = Get-Date -Format 'dd.MM-hh:mm'


    #Calculate execution time of last cmd and convert to milliseconds, seconds or minutes
    $LastCommand = Get-History -Count 1
    if ($lastCommand) { $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds }

    if ($RunTime -ge 60) {
        $ts = [timespan]::fromseconds($RunTime)
        $min, $sec = ($ts.ToString("mm\:ss")).Split(":")
        $ElapsedTime = -join ($min, " min ", $sec, " sec")
    }
    else {
        $ElapsedTime = [math]::Round(($RunTime), 2)
        $ElapsedTime = -join (($ElapsedTime.ToString()), " sec")
    }

    if (Test-Path .git) {
        #Decorate the CMD Prompt
        Write-Host "$CmdPromptCurrentFolder>" -ForegroundColor Green -NoNewline
        Write-Host "$date>$branchName" -ForegroundColor DarkCyan -NoNewline
    }
    else {
        # we're not in a repo so don't bother displaying branch name/sha
        #Decorate the CMD Prompt
        Write-Host "$CmdPromptCurrentFolder>" -ForegroundColor Green -NoNewline
        Write-Host "$date" -ForegroundColor DarkCyan -NoNewline
    }

}
#end prompt function

Function searchGithub {
    $searchGit = read-host "searching for";
    [string[]]$Qg = $searchGit.split(" ");
    $eg = '';
    for($ig=0; $ig -lt $Qg.length; $ig++){
           $eg += $Qg[$ig]+'+'
        }
    echo $eg;
    start msedge https://github.com/search?q=$eg

    }

Function google{
    $searchQuery = Read-Host "searching for";
    [string[]]$Q = $searchQuery.split(" ");
    $e = '';
    for($i=0; $i -lt $Q.length; $i++){
           $e += $Q[$i]+'+'
        }
    echo $e;
    start msedge https://www.google.com/search?q=$e
    }

Function youtube{
    $youtubeQuery = read-host "searching for";
    [string[]]$UQ = $youtubeQuery.split(" ");
    $ue = '';
    for($ui=0; $ui -lt $UQ.length; $ui++){
        $ue += $UQ[$ui]+'+'
    }
    echo $ue;
    start msedge https://www.youtube.com/results?search_query=$ue
    }

Function getfile{
                param(
                    $fileName
                )
                ls . -Recurse -File $fileName
                }

Function getDir{
                param(
                    $dirName
                )
                ls . -Recurse -Directory $dirName
                }

Function addgitignore{
                git rm -rf --cached .
                Remove-Item -Path .vscode -Recurse
                set-content .gitignore '
                                        .vscode/*
                                        !.vscode/settings.json
                                        !.vscode/tasks.json
                                        !.vscode/launch.json
                                        !.vscode/extensions.json
                                        !.vscode/*.code-snippets

                                        # Local History for Visual Studio Code
                                        .history/

                                        # Built Visual Studio Code Extensions
                                        *.vsix'
                }

Function newGit{
                    $remoteLink = Read-Host "past your remote link here please"
                    git init
                    git add .
                    git commit -m "first commit"
                    git branch -M main
                    git remote add origin $remoteLink
                    git push -u origin main

                }


