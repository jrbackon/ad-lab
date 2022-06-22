param([Parameter(Mandatory=$true)] $JSONFile,
    [switch]$undo
)

function CreateADGroup(){
    param([Parameter(Mandatory=$true)] $groupobject)

    $name = $groupobject.name
    New-ADGroup -name $name -GroupScope Global
}

function RemoveADGroup(){
    param([Parameter(Mandatory=$true)] $groupobject)

    $name = $groupobject.name
    Remove-ADGroup -Identity $name -Confirm:$false
}

function CreateADUser(){
    param([Parameter(Mandatory=$true)] $userObject )

    # Pull out the name from the JSON object
    $name = $userObject.name
    $password = $userObject.password

    # Generate a 'first initial, last name" structure for username
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    $principalname = $username

    # Actually create the AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    # Add the user to its appropriate group
    foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $name NOT added to group $group_name because it does not exist"
        }
    }
}

function RemoveADUser(){
    param([Parameter(Mandatory=$true)] $userobject)

    $name = $userobject.name
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    Remove-ADUser -Identity $samAccountName -Confirm:$false
}

function WeakenPasswordPolicy(){
    secedit /export /cfg c:\Windows\Tasks\secpol.cfg
    (Get-Content C:\Windows\Tasks\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0").replace("MinimumPasswordLength = 7", "MinimumPasswordLength = 1") | Out-File C:\Windows\Tasks\secpol.cfg
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\Windows\Tasks\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -force c:\Windows\Tasks\secpol.cfg -confirm:$false 
}

function StrengthenPasswordPolicy(){
    secedit /export /cfg c:\Windows\Tasks\secpol.cfg
    (Get-Content C:\Windows\Tasks\secpol.cfg).replace("PasswordComplexity = 0", "PasswordComplexity = 1").replace("MinimumPasswordLength = 1", "MinimumPasswordLength = 7") | Out-File C:\Windows\Tasks\secpol.cfg
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\Windows\Tasks\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -force c:\Windows\Tasks\secpol.cfg -confirm:$false 
}



$json = ( Get-Content $JSONFile | ConvertFrom-Json)
$Global:Domain = $json.domain

if ( -not $undo) {
    WeakenPasswordPolicy

    foreach ( $group in $json.groups ){
        CreateADGroup $group
    }
    
    foreach ( $user in $json.users ){
        CreateADUser $user
    }    
}else{
    StrengthenPasswordPolicy
    
    foreach ( $user in $json.users ){
        RemoveADUser $user
    }    

    foreach ( $group in $json.groups ){
        RemoveADGroup $group
    }
}


