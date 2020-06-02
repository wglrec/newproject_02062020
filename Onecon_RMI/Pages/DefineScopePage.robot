*** Settings ***
Library    Collections    
Library    SeleniumLibrary
Library    String
Resource   CommonFunctions.robot
Resource    HomePage.robot
Resource    SelectRawMaterial.robot

*** Variables ***

*** Keywords ***
Verify define scope page
    [Documentation]   verify whether the define scope page loaded by checking the menu active status
    # Validate the page should contains the attribute    //li[@id='define-scope']    class	rmi-planning-nav-item rmi-planning-nav-item-active   
    Page Should Contain Element    //img[@title='back to my scopes']   Back to my scope icon not found     

Verify other columns not enabled in define scope page
    Validate the page should contains the attribute    //div[@class="cuppa-dropdown"]//span[contains(text(),'Supplier')]/..    class    c-btn disabled
    Validate the page should contains the attribute    //div[@class="cuppa-dropdown"]//span[contains(text(),'Division')]/..    class    c-btn disabled
    # Validate the page should contains the attribute    //div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[text()='Plant']]/preceding-sibling::div)+1]//div[@class='selected-list']/div    class    c-btn disabled
    # Validate the page should contains the attribute    //div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[text()='Business unit']]/preceding-sibling::div)+1]//div[@class='selected-list']/div    class    c-btn disabled
    # Validate the page should contains the attribute    //div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[text()='Profit center']]/preceding-sibling::div)+1]//div[@class='selected-list']/div    class    c-btn disabled
    log    Rb suppl,div,plant,BU and prctc are not enabled

Add new container and edit container name
    [Documentation]    Editing the scope name
    [Arguments]    ${type}
    ${json}=    Get raw material from Json file    ${type}    
    ${containerName}=    Set Variable    ${json['container']}
    Set Global Variable    ${containerName}
    #Delete the contaier before creating new one
    Delete the container
    #Create new container
    Sleep    5s
    Wait for angular loading image    20s
    Add new scope    ${type}
    verify define scope page
    Wait Until Page Contains Element    //img[@title='edit container name']
    Click Image    //img[@title='edit container name']
    #Wait until edit and save icon visible
    Wait Until Page Contains Element    //img[@title='save container name']    
    Wait Until Page Contains Element    //img[@title='decline changed']
    #Clear text field and input the container name
    sleep    3s
    Clear Element Text    //input[@class='oc-control-textual-input']
    Input Text    //input[@class='oc-control-textual-input']    ${containerName}
    Click Image    //img[@title='save container name'] 
    sleep    2s
    Element Text Should Be    //*[@class='app-notifications']//div[contains(@class,'success')]//p    Scope name updated successfully.    message=Failed in container name edit
    Click Element    //*[@class='close']
    ${temp}=    Get Text    //img[@title='edit container name']/../..      
    Run Keyword If    '${temp}'=='${containerName}'
    ...    Run Keywords
    ...    Sleep    3s    
    ...    AND    log    Scope name updated successfully
    ...    ELSE
    ...    Run Keyword 
    ...    Fail    
    
Back to my scope page
    [Documentation]    Navigates to My scope page
    Sleep    2s
    UD_Click element    //img[@title='back to my scopes']    back to my scope
    Verify my scope page
    Log    Navigates to My scope page   
    
Add new line item
    [Documentation]    Selects the master data
    [Arguments]    ${masterData}
    #Get the matfield from JSON
    ${lineItem}    Get raw material from Json file    ${masterData}    
    # ${rawMaterial}    Set Variable    ${json['rawMat']}
    Set Global Variable    ${lineItem}
    Set Global Variable    ${masterData}        
    # ${arrow}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[contains(@class,'flex-container')]/div[count(//*[@class='bg-white']//div[contains(@class,'flex-container')]/div[//div[text()='${masterData}']]/preceding-sibling::div)+1]//div[@class='cuppa-dropdown']
    ${arrow}    Set Variable    //div[@class='bg-white']/div//div[@class='c-btn']
    ${txtField}    Set Variable    //div[@class='bg-white']/div//input[contains(@placeholder,'Mat Field')]
    ${checkBox}    Set Variable    (//div[@class='bg-white']/div//span[contains(text(),'Mat Field')]/following::li)[1]
    UD_Click element    ${arrow}     arrow
    Clear Element Text    ${txtField}        
    Input Text    ${txtField}     ${lineItem}
    Sleep    4s
    Wait Until Page Contains Element    ${checkBox}    20s
    Sleep    2s
    UD_Click element    ${checkBox}    checkbox
    UD_Click element    ${arrow}	arrow

Create master data by adding all the fields
    [Documentation]    Add mat field,RB supplier,Division,plant,BU and PRCTR
    @{columns}    Create List    Mat Field    Supplier    Division    Plant    Business Unit    Profit Center
    ${json}    Get raw material from Json file    allfields
    ${count}    Set Variable    1       
    FOR    ${masterData}    IN    @{columns}
    ${arrow}=    Set Variable    (//div[@class='bg-white']/div//div[@class='c-btn'])[${count}]
    ${txtField}=    Set Variable    //div[@class='bg-white']/div//input[contains(@placeholder,'${masterData}')]
    ${checkBox}=    Set Variable    (//div[@class='bg-white']/div//span[contains(text(),'${masterData}')]/following::li[@class='pure-checkbox'])[1]    
    UD_Click element    ${arrow}    arrow
    Input Text    ${txtField}      ${json['${masterData}']}
    Sleep    3s
    Wait Until Page Contains Element    ${checkBox}    10s
    UD_Click element    ${checkBox}    checkbox
    UD_Click element    ${arrow}    arrow
    ${count}=    Evaluate    ${count}+1
    END 

Add new line item for part number planning
    [Documentation]    Add mat field,RB supplier,Division,plant,BU,PRCTR and Part number
    [Arguments]    ${value}
    @{columns}    Create List    Mat Field    RB Supplier    Division    Plant    Business unit    Profit center    Part Number    
    ${json}    Get raw material from Json file    ${value}
    ${partNo}    Set Variable    ${json['Part Number']}
     Set Global Variable    ${partNo}
    FOR    ${masterData}    IN    @{columns}
	    ${arrow}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[count(//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[oc-h3/div[contains(normalize-space(),'${masterData}')]]/preceding-sibling::div)+1]//div[@class='cuppa-dropdown']
	    ${txtField}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[count(//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[oc-h3/div[contains(normalize-space(),'${masterData}')]]/preceding-sibling::div)+1]//input[contains(@placeholder,'Search ')]
	    ${dropDwn}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[count(//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[oc-h3/div[contains(normalize-space(),'${masterData}')]]/preceding-sibling::div)+1]//div[@class="list-area"]
	    ${checkBox}=    Catenate    SEPARATOR=    xpath=(//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[count(//*[@class='bg-white']//div[@class='flex-container oc-group-box']/div[oc-h3/div[contains(normalize-space(),'${masterData}')]]/preceding-sibling::div)+1]//input[@type='checkbox']/following::label)[1]
	    UD_Click element    ${arrow}    arrow
	    Sleep    3s
	    Input Text    ${txtField}      ${json['${masterData}']}
	    Sleep    3s
	    Wait for angular loading image    10s
	    UD_Click element    ${checkBox}    checkBox
	    Sleep    2s
    END
    ${lineItem}    Set Variable    ${json['Mat Field']}
    Set Global Variable    ${lineItem}
    # \    UD_Click element    ${arrow}     arrow

Add new line items for part number planning
    [Documentation]    adding 2 new line items for part no planning container
    [Arguments]    ${value}
    Add new line item for part number planning    ${value}
    Click on add button
    Get all the selected masterdata for part no planning

Get all the selected masterdata
    [Documentation]    Get the selected master data in the first line item and store in array
    @{columns}    Create List    Mat Field    RB Supplier    Division    Plant    Business unit    Profit Center
    &{allMasterData}    Create Dictionary
      
    FOR    ${data}    IN	@{columns}
	    ${temp}    Get Text    //div[@wj-part='cells']/div[2]/div[count(//div[@wj-part='chcells']/div/div[text()='${data}']/preceding-sibling::div)+1]
	    Set To Dictionary    ${allMasterData}    ${data}    ${temp}
    END
    Set Global Variable    &{allMasterData}   
    
Get all the selected masterdata for part no planning
    [Documentation]    Get the selected master data in the first line item and store in array
    @{columns}    Create List    Mat Field    RB Supplier    Division    Plant    Business unit    Profit Center    Part Number
    &{allMasterData}    Create Dictionary
    :FOR    ${data}    IN	@{columns}
    \    ${temp}    Get Text    //div[@wj-part='cells']/div[2]/div[count(//div[@wj-part='chcells']/div/div[text()='${data}']/preceding-sibling::div)+1]
    \    Set To Dictionary    ${allMasterData}    ${data}    ${temp}
    Set Global Variable    &{allMasterData}         

print data
    ${arrow}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[text()='${masterData}']]/preceding-sibling::div)+1]/angular2-multiselect
    ${txtField}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[text()='${masterData}']]/preceding-sibling::div)+1]//input
    ${dropDwn}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[text()='${masterData}']]/preceding-sibling::div)+1]//div[@class="list-area"]
    ${checkBox}=    Catenate    SEPARATOR=    xpath=//*[@class='bg-white']//div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[text()='${masterData}']]/preceding-sibling::div)+1]//input[@type='checkbox']/following::label
    Click Element    xpath=//*[@class='bg-white']//div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[contains(text(),'${masterData}')]]/preceding-sibling::div)+1]/angular2-multiselect 
    @{web}=    Get WebElements    //*[@class='bg-white']//div[@class='flex-container']/div[count(//*[@class='bg-white']//div[@class='flex-container']/div[h5[contains(text(),'Mat Field')]]/preceding-sibling::div)+1]//li//label
    FOR    ${ELEMENT}    IN     @{web}
	    ${tmpData}=    Get Text    ${ELEMENT}
	    Log To Console    ${tmpData}
    END
   

Delete the line item
    [Documentation]    Delete the added line item     
    #Validate the edit and delete icon
    ${editLineItem}    Set Variable    //div[@class='wj-cells' and @role='grid']/div[2]/div[1]//following::oc-icon[@iconname='ICN_16_EDIT']
    ${deleteLineItem}    Set Variable    //div[@class='wj-cells' and @role='grid']/div[2]/div[1]//following::oc-icon[@iconname='ICN_16_DEL']
    Page Should Contain Element    ${editLineItem}
    Page Should Contain Element    ${deleteLineItem}
    ${t}=    Get Text    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]
    Should Be Equal    ${t}    ${lineItem}
    UD_Click element    ${deleteLineItem}    delete
    Wait Until Page Contains Element    //div[@class="modal-content"]
    Click Button    //div[@class="modal-content"]//*[text()='Yes']
    Click on save button to save the line item
    # Element Should Not Be Visible    locator    
    Page Should Not Contain Element    ${deleteLineItem}    

Filter for line item
    [Documentation]    Filter for line item and validate the data
    UD_Click element    //div[@class='wj-cell wj-header wj-filter-off' and contains(text(),'${masterData}')]/div    filter
    Wait Until Page Contains Element    //div[@class="wj-control"]//input    
    Input Text    //div[@class="wj-control"]//input    ${lineItem}
    UD_Click element    //a[@wj-part='btn-apply']    apply
    Page Should Contain Element    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]//following::oc-icon[@iconname='ICN_16_EDIT']
    Page Should Contain Element    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]//following::oc-icon[@iconname='ICN_16_DEL']
    ${t}=    Get Text    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]
    Should Be Equal    ${t}    ${lineItem} 
       
Edit the line item
    [Documentation]    Edit the already existing line item
    Wait Until Element Is Visible    //div[@class='wj-row' and @aria-selected='true']/div    5s
    ${editLineItem}    Get raw material from Json file    editMatfield  
    ${checkBox}    Set Variable    xpath=//*[@id='edit-scopes']//div[count(//*[@id='edit-scopes']/div[h5[contains(text(),'${masterData}')]]/preceding-sibling::div)+1]//input[@type='checkbox']/following::label   
    Page Should Contain Element    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]//following::oc-icon[@iconname='ICN_16_EDIT']
    Wait Until Element Is Visible    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]//following::oc-icon[@iconname='ICN_16_EDIT']    10s
    sleep    3s
    UD_Click element    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]//following::oc-icon[@iconname='ICN_16_EDIT']    edit
    Wait Until Page Contains Element    //div[@id='edit-scopes']
    Page Should Contain Element    //*[@id='edit-scopes']//img[@title='Confirm']
    Page Should Contain Element    //*[@id='edit-scopes']//img[@title='Cancel']
    UD_Click element    (//*[@id='edit-scopes']//div[@class='cuppa-dropdown'])[count(//*[@id='edit-scopes']/div[h5[contains(text(),'${masterData}')]]/preceding-sibling::div)+1]    dropdown    
    Input Text    (//div[@id='edit-scopes']/div//input)[1]    ${editLineItem}
    Sleep    3s
    Wait Until Page Contains Element    ${checkBox}    10s
    UD_Click element    ${checkBox}    checkBox
    # UD_Click element    //*[@id='_dropdown']/div
    # Wait Until Element Is Not Visible    //*[@id='edit-scopes']//*[contains(text(),'${masterData}')]/..//input   
    Sleep    5s 
    UD_Click element    //*[@id='edit-scopes']//img[@title='Confirm']    conform
    # Wait Until Element Is Not Visible    //*[@id='edit-scopes']
    ${lineItem}    Set Variable    ${editLineItem}
    Set Global Variable    ${lineItem}        


Edit the line item for part no planning
    [Documentation]    Edit the already existing line item for part no planning container
    ${json}    Get raw material from Json file    editlineitem  
      
    Page Should Contain Element    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]//following::oc-icon[@iconname='ICN_16_EDIT']
    UD_Click element    //div[@class='wj-cells' and @role='grid']/div[2]/div[count(//div[@class='wj-cells' and @role='grid']/div[1]/div[text()='${masterData}']/preceding-sibling::div)+1]//following::oc-icon[@iconname='ICN_16_EDIT']    edit
    Wait Until Page Contains Element    //div[@id='edit-scopes']
    Page Should Contain Element    //*[@id='edit-scopes']//img[@title='Confirm']
    Page Should Contain Element    //*[@id='edit-scopes']//img[@title='Cancel']
    
    #Editing all the column values
    @{columns}    Create List    Mat Field    RB Supplier    Division    Plant    Business unit    Profit Center    Part Number    
    # ${partNo}    Set Variable    ${json['partnumber2']}
    Set Global Variable    ${partNo}
    FOR    ${masterData}    IN    @{columns}
        Sleep    2s
        ${checkBox}    Set Variable    (//*[@id='edit-scopes']//div[count(//*[@id='edit-scopes']/div[*[contains(normalize-space(.),'${masterData}')]]/preceding-sibling::div)+1]//label)[2] 
	    UD_Click element    (//*[@id='edit-scopes']//div[@class='cuppa-dropdown'])[count(//*[@id='edit-scopes']/div[*[contains(normalize-space(.),'${masterData}')]]/preceding-sibling::div)+1]    dropdown    
	    Sleep    2s
	    Input Text    (//*[@id='edit-scopes']//div[@class='cuppa-dropdown'])[count(//*[@id='edit-scopes']/div[*[contains(normalize-space(.),'${masterData}')]]/preceding-sibling::div)+1]//input[@placeholder='Search']    ${json['${masterData}']}
	    Sleep    3s
        Wait Until Page Contains Element    ${checkBox}    10s
	    UD_Click element    ${checkBox}    checkBox
	    # ${lineItem}=    Set Variable    ${editLineItem}
	    # Set Global Variable    ${lineItem}
    END
    #Store the matield id
    ${lineItem}    Set Variable    ${json['Mat Field']}
    Set Global Variable    ${lineItem}
    sleep    5s    
	UD_Click element    //*[@id='edit-scopes']//img[@title='Confirm']    conform
	Wait Until Element Is Not Visible    //*[@id='edit-scopes']
     
Click on add button
     [Documentation]    Click on add button
     Click Button    //button[contains(text(),'Add')]
     Wait Until Page Contains Element    //*[@title='Delete']    error=Matfield is already there in another container        
     Page Should Contain Element    //*[@title='Delete'] 
     Page Should Contain Element    //*[@title='Edit']

Click on save button to save the line item
     [Documentation]    Click on Save button and validate the success message
     UD_Click element    //img[@title='save changes']    save
     verify the success message    Message : Container scope line items were saved successfully
             
Click on save and next button to save line item
    [Documentation]    Click on Save and next button
     UD_Click element    //a[contains(@class,'oc-button-prio-1')]    save and next
     Verify the success message    Message : Container scope line items were saved successfully
     Wait for angular loading image    20s
     Verify raw material page
     #wait untill message disaaperas
     # Wait Until Page Does Not Contain Element    //*[@class='core-notification ng-star-inserted']//div[@class='core-notification-message']/p    5s
         
Validate confirm lose of data msg
    [Documentation]    Validate the conform lose meessage
    Sleep    2s
    UD_Click element    //img[@title='back to my scopes']    back to my scopes
    Wait Until Page Contains Element    //div[@class="modal-content"]
    UD_Click button    //div[@class="modal-content"]//*[text()='Yes']    yes  
    Element Text Should Be    //*[@class='h1-class']    All Scopes
    Log    Navigates to My scope page     
      
Navigate to calculate RMI page
    [Documentation]    Click the Next button in define scope and in Raw material page
    ...    without validating any message
    Click on next button
    Click on next button 
     
Validate error message while adding duplicate line item for general planning
    [Documentation]    CPREQ-24995 test case specific keyword
    ...    validate the error msg when adding duplicate line item             
    Create master data by adding all the fields 
    Click on add button
    Click on save button to save the line item
    Create master data by adding all the fields
    Click on add button
    # Click Button    //button[@class='oc-button-prio-2']
    Verify the error message    Error : The selected line item combination(s) either overlaps or already exists in one or more containers. Please change the selection.

Validate error message while adding duplicate line item for partnumber planning
    [Documentation]    CPREQ-24995 test case specifi keyword
    ...    validate the error msg when adding duplicate line item             
    Add new line item for part number planning    partnumber
    Click on add button
    Click on save button to save the line item
    Add new line item for part number planning    partnumber
    Click on add button
    # Click Button    //button[@class='oc-button-prio-2']
    Verify the error message    Error : The selected line item combination(s) either overlaps or already exists in one or more containers. Please change the selection.
     
Validate all the Mat fields in UI against DB
    [Documentation]    Validates all the matfield whose basevolume>0
    ...    in general planning
 
    @{dbValues}    Create List
    ${uiValues}    Create List
    #Get the values from DB    
    ${dbValues}    Connect Onecon RMI database and return as list    select distinct(mcr_material_field.code) from mcr_material_field inner join base_volume on base_volume.mcr_material_field_id = mcr_material_field.id and base_volume.base_volume<>0
    ${arrow}    Set Variable    //div[@class='bg-white']/div//div[@class='c-btn']
    ${txtField}    Set Variable    //div[@class='bg-white']/div//input[contains(@placeholder,'${masterData}')]
    ${checkBox}    Set Variable    (//div[@class='bg-white']/div//span[contains(text(),'Mat Field')]/following::li[@class='pure-checkbox'])[1]
    #Get from UI
    UD_Click element    ${arrow}    arrow
    @{web}=    Get WebElements    //rmi-planning-define-scope//ul[@class='lazyContainer']//li[@class='pure-checkbox']
    FOR    ${ELEMENT}    IN     @{web}
	    ${temp}    Get Text    ${ELEMENT}
	    ${len}    Get Length    ${temp}
	    Run Keyword If    ${len}>0    Append To List    ${uiValues}    ${temp}    
	END        
   Sort List    ${dbValues}
   Sort List    ${uiValues}
   Lists Should Be Equal    ${dbValues}    ${uiValues}    msg=Failed in validating the matfields  
   
Sample_print_delete

    @{dbValues}    Create List
    ${uiValues}    Create List
    #Get the values from DB    
    ${dbValues}    Connect Onecon RMI database and return as list    select distinct(mcr_material_field.code) from mcr_material_field inner join base_volume on base_volume.mcr_material_field_id = mcr_material_field.id and base_volume.base_volume<>0
    ${arrow}    Set Variable    //div[@class='bg-white']/div//div[@class='c-btn']
    ${txtField}    Set Variable    //div[@class='bg-white']/div//input[contains(@placeholder,'${masterData}')]
    ${checkBox}    Set Variable    (//div[@class='bg-white']/div//span[contains(text(),'Mat Field')]/following::li[@class='pure-checkbox'])[1]
    #Get from UI
    UD_Click element    ${arrow}    arrow
    @{web}=    Get WebElements    //rmi-planning-define-scope//div[@class='bg-white']/div//ul/span/li[@class='pure-checkbox']    
    :FOR    ${ELEMENT}    IN     @{web}
    \    ${temp}=    Get Text    ${ELEMENT}
    \    Append To List    ${uiValues}    ${temp}        
   Sort List    ${dbValues}
   Sort List    ${uiValues}
   Lists Should Be Equal    ${dbValues}    ${uiValues}    msg=Failed in validating the matfields     
    
Add line item mat field k1-k2 with all fields 
    [Documentation]    Add mat field,RB supplier,Division,plant,BU and PRCTR for plastic mat field
    @{columns}    Create List    Mat Field    Supplier    Division    Plant    Business Unit    Profit Center
    ${json}    Get raw material from Json file    plasticfields
    ${count}    Set Variable    1       
    FOR    ${masterData}    IN    @{columns}
        ${arrow}=    Set Variable    (//div[@class='bg-white']/div//div[@class='c-btn'])[${count}]
        ${txtField}=    Set Variable    //div[@class='bg-white']/div//input[contains(@placeholder,'${masterData}')]
        ${checkBox}=    Set Variable    (//div[@class='bg-white']/div//span[contains(text(),'${masterData}')]/following::li[@class='pure-checkbox'])[1]    
        UD_Click element    ${arrow}    arrow
        Input Text    ${txtField}      ${json['${masterData}']}
        Sleep    4s
        Wait Until Page Contains Element    ${checkBox}    10s
        UD_Click element    ${checkBox}    checkbox
        UD_Click element    ${arrow}    arrow
        ${count}=    Evaluate    ${count}+1 
    END