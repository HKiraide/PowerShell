$old_log = "path\to\file\with\data\old.txt"    #file created to save the original data before the changes
$new_arq = "path\to\file\with\data\new.txt"    #file created to make the middle man to old and edited data
$arq_log = "path\to\file\with\data\main.txt"   #main file with the original data
$process_name = "proccess name"                #process name
$process_path = "path\to\proccess\.exe"        #executable path


function CleanFile{
$read_arq = Get-Content $arq_log                                            
$clean_log = $read_arq -Match 'REGEXP PATTERN'                    
$clean_log | Out-File -FilePath $new_arq                                    
Write-Host '===== STAGE 1 : OK ====='-ForegroundColor Green -BackgroundColor Black                                      
Start-Sleep -Seconds 2
if (Test-Path $old_log) {                                                   
    Remove-Item $old_log -Force                                             
    Write-Host '===== STAGE 2 : OK ====='-ForegroundColor Green -BackgroundColor Black
    Write-Host 'OLD file deleted' -ForegroundColor Blue -BackgroundColor Black   
}else{
    Write-Host '===== STAGE 2 : OK ====='-ForegroundColor Green -BackgroundColor Black
    Write-Host 'Unable to find OLD' -ForegroundColor Blue -BackgroundColor Black
}
Get-Content $arq_log | Out-File $old_log                                    
Start-Sleep -Seconds 2                                                      
Remove-Item $arq_log                                                        
Start-Sleep -Seconds 2
Get-Content $new_arq | Out-File $arq_log                                    
Remove-Item $new_arq                                                        
Write-Host "===== STAGE 3 : OK ===== " -ForegroundColor Green 
Write-Host "File changed with success ===> " $arq_log -ForegroundColor Cyan
} 
function Process_Restart{
    if ($process_name) {                                                    
        Write-Host 'Stopping process' -ForegroundColor Magenta            
        Stop-Process -Name $process_name -Force                             
        Clean_File                                                        
        Start-Process $process_path                                         
        Write-Host "Process Restart" -ForegroundColor Magenta
    }
    else {
        Write-Host "Couldn't find process" -ForegroundColor Red
    }
}

if(Test-Path $arq_log){
    Process_Restart
}else {
    Write-Host "Main file not indentified" -ForegroundColor Blue -BackgroundColor Yellow    
}

