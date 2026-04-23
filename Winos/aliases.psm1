Set-Alias ll ls
Set-Alias vim nvim
Set-Alias grep Select-String
Set-Alias which Get-Command
Set-Alias touch New-Item

function Invoke-RipGrep {
    # default to 'smart-case' searches with '-S'
    & (Get-Command rg -CommandType Application) -S @args
}
Set-Alias rg Invoke-RipGrep
