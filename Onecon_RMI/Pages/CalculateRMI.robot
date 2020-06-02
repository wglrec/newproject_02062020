*** Settings ***
Library    SeleniumLibrary
#Library    AngularJSLibrary
Library    Collections
Library    OperatingSystem
Library    String
Library    OpenPyxlLibrary
Resource    ../Pages/DefineScopePage.robot
Resource    ../Resources/JsonReader.robot
Resource    ../Pages/HomePage.robot
Resource    ../Pages/CommonFunctions.robot
Resource    ../Pages/SelectRawMaterial.robot
Resource    ../Pages/CalculateRMI.robot
Resource   ../Resources/DBAccess.robot
Resource    Queries.robot
#

*** Keywords ***
Verify calculate RMI page
    [Documentation]   verify whether the Calculate RMI page loaded by checking the menu active status
    # Validate the page should contains the attribute     //li[@id='calculate-rmi']    class    menu-item black not-active active
    # Page Should Contain Element    //button[@id='rmi-planning-back']
    Page Should Contain Element    //img[@title='back to my scopes']   Back to my scope icon not found     
    
Validate added raw material and matshare
    [Documentation]    Validate the raw material and matshare
    Verify calculate RMI page
    ${rms}=    Get Text    //div[@class="calc-rmi-collapse-header"]//h4
    ${source}=    Catenate    SEPARATOR=    ${rawMaterial} (+${matShare}%)
    Should Be Equal    ${source}    ${rms}

Expand or collapse the container
    [Documentation]    Expand or collapse the price model container in Calculate RMI page
    [Arguments]    ${rawmat}
    Sleep    3s
    Wait Until Page Contains Element    //*[@class='calc-rmi-collapse-header']/div[h4[contains(text(),'${rawmat}')]]/..//oc-icon
    UD_Click element    //*[@class='calc-rmi-collapse-header']/div[h4[contains(text(),'${rawmat}')]]/..//oc-icon

Select first price model
    [Documentation]    select the first price model
    [Arguments]    ${rwMt}
    Verify calculate RMI page
    ${json}=    Get raw material from Json file    ${rwMt}
    ${priceRef}=    Set Variable    ${json['firstPrice']}
    Set Global Variable    ${priceRef}    
    # Expand the selection
    Expand or collapse the container    ${rwMt}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Verify all the fields in first price model window
    Select values in price model dropdown field    //span[text()='Select Price Reference']    ${json['firstPrice']}
    Wait Until Page Contains Element    //div[@class='selected-list']//span[contains(text(),'${priceRef}')]
    #add aboluste adder percentage
    Wait Until Element Is Visible    //span[text()='Select Regional Price Percentage']    10s
    Select values in price model dropdown field    //span[text()='Select Regional Price Percentage']    ${json['adder']}
    Sleep    2s            
    Save the price model
    
Select first price model with currency
    [Documentation]    select the first price model with currecny
    [Arguments]    ${rwMt}    ${currency}
    ${json}=    Get raw material from Json file    ${rwMt}
    ${priceRef}=    Set Variable    ${json['firstPrice']}
    Set Global Variable    ${priceRef}    
    Expand or collapse the container    ${rwMt}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Verify all the fields in first price model window
    Select values in price model dropdown field    //span[text()='Select Price Reference']    ${priceRef}
    Wait Until Page Contains Element    //div[@class='selected-list']//span[contains(text(),'${priceRef}')]
    #add aboluste adder percentage
    Select values in price model dropdown field    //span[text()='Select Regional Price Percentage']    ${json['adder']}
    Select values in price model dropdown field    //span[text()='Select Supplier Currency']    ${currency}
    Sleep    2s            
    Save the price model

Select first price model for plastic raw material
    [Documentation]    select the first price model for plastic without currency
    [Arguments]    ${rwMt}
    ${json}=    Get raw material from Json file    ${rwMt}
    ${priceRef}=    Set Variable    ${json['firstPrice']}
    ${fix}=    Set Variable    ${json['fixation']}
    Set Global Variable    ${priceRef}    
    Expand or collapse the container    ${rwMt}
    Validate the price models displayed for plastic
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Verify all the fields in first price model window
    Select values in price model dropdown field    //span[text()='Select Price Reference']    ${priceRef}
    Wait Until Page Contains Element    //div[@class='selected-list']//span[contains(text(),'${priceRef}')]
    Select values in price model dropdown field    //span[text()='Select fixation rate']    ${fix}
    Sleep    2s            
    Save the price model
    
Select first price model for plastic raw material with currency
    [Documentation]    select the first price model for plastic with currency
    [Arguments]    ${rwMt}
    ${json}=    Get raw material from Json file    ${rwMt}
    ${priceRef}=    Set Variable    ${json['firstPrice']}
    ${cur}=    Set Variable    ${json['currency']}
    ${fix}=    Set Variable    ${json['fixation']}
    Set Global Variable    ${priceRef}    
    Expand or collapse the container    ${rwMt}
    Validate the price models displayed for plastic
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Verify all the fields in first price model window
    Select values in price model dropdown field    //span[text()='Select Price Reference']    ${priceRef}
    Wait Until Page Contains Element    //div[@class='selected-list']//span[contains(text(),'${priceRef}')]
    Select values in price model dropdown field    //span[text()='Select Supplier Currency']    ${cur}
    Select values in price model dropdown field    //span[text()='Select fixation rate']    ${fix}
    Sleep    2s            
    Save the price model
    
Save the price model
    [Documentation]    Click on Set price reference button to save price models
    Sleep    2s
    UD_Click button    //button[normalize-space(.)='Set price reference']    Set price reference
    Sleep    2s
    Wait for angular loading image    5s    
    
Verify the base and compare price for first price model
    [Documentation]    Verify the base and compare price for first price model
    # Wait Until Page Contains Element    //*[@class='calc-rmi-collapse-header']/div[h4[contains(text(),'${rawMaterial}')]]/..//oc-icon
    UD_Click element    //*[@class='calc-rmi-collapse-header']/div[h4[contains(text(),'${rawMaterial}')]]/..//oc-icon    oc-icon

    ${basePrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[2]
    ${comPrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[3]
    ${rmiTotal}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[4]
    ${rmiPercent}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[5]
    
    Set Global Variable    ${rmiTotal} 
    Set Global Variable    ${rmiPercent}   
    #Get price details from DB
    ${priceRefId}    Connect Onecon RMI database and run query    SELECT VALUE FROM CONTAINER_PRICE_MODEL_PROFILE WHERE CONTAINER_PRICE_MODEL_ID IN (SELECT ID FROM CONTAINER_PRICE_MODEL WHERE CONTAINER_RAW_MATERIAL_ID IN (SELECT ID FROM CONTAINER_RAW_MATERIAL WHERE CONTAINER_ID IN (SELECT ID FROM CONTAINER WHERE NAME = '${containerName}')))
    ${bDB}    Connect Onecon RMI database and run query    select base_price from cp_mac_price where price_reference_id = '${priceRefId}' and version_id='1'
    ${cDB}    Connect Onecon RMI database and run query    select roy_price from cp_mac_price where price_reference_id = '${priceRefId}' and version_id='1'
    ${bDB}    Convert To Number    ${bDB}    2
    ${cDB}    Convert To Number    ${cDB}    2
    ${basePrice}    Convert To Number    ${basePrice}    1
    ${comPrice}    Convert To Number    ${comPrice}    1
    #Base and compare Price format djusted as per UI
    ${bDB}    Price format adjusted as per UI    ${bDB}
    ${cDB}    Price format adjusted as per UI    ${cDB}
    Should Be Equal    ${basePrice}    ${bDB}
    Should Be Equal    ${comPrice}     ${CDB}

Validate the currency and order unit in calculate rmi page
    [Documentation]    Validate the currency and order unit in for base price
    [Arguments]    ${orderUnits}
    #Collapse the selected price model
    # UD_Click element    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::img[1]    expand icon
    #GEt the currency and order unit & validate
    # ${units}    Get Text    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h5[text()='Base Price']/following::span[3]
    ${units}    Get Text    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'Copper')]/../following::h2[1]/span
    # ${units}    Get Text    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'Copper')]/../following::div[1]/div[2]/div[2]/span[2]
    Should Be Equal    ${orderUnits}    ${units}    msg=Failed in validating Currency and order unit
 
Validate the currency and order unit in collapse mode
    [Documentation]    Validate the currency and order unit in aggregate level
    #Collapse the selected price model
    Page Should Contain Element    //oc-tooltip[1]//h2/span    Currency and order unit is missing for compare price
    Page Should Contain Element    //oc-tooltip[1]//h2/span    Currency and order unit is missing for compare price
    
Verify the RMI total and RMI percent is updated if matshare changed
   [Documentation]         Verify the RMI total and RMI percent
   # Validate the page should contains the attribute     //li[@id='calculate-rmi']    class    menu-item black active\\
    ${rmitl}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[4]
    ${rmiper}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[5]
   # ${rmitl}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'RMI total')]//following::span[2]/b
   # ${rmiper}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'RMI %')]//following::span
   Should Not Be Equal    ${rmiTotal}    ${rmitl}
   Should Not Be Equal    ${rmiPercent}    ${rmiper}    

Get price and return the digits
    [Documentation]    get the prices from the UI
    [Arguments]    ${locator}
    ${price}    Get Text            ${locator}
    #Remove characters from the string - 22,467.74 AED / t
    ${price}    Replace String Using Regexp    ${price}    [^\\d.]    , 
    ${price}    Remove String    ${price}    ,  
    # ${price}    Get Regexp Matches    ${price}    [^\\d.]
    ${price}    Convert To Number    ${price}    2  
    Return From Keyword    ${price}
    
Get RMI total and percent
    [Documentation]    get RMI total and percent
    [Arguments]    ${locator}
    ${price}    Get Text            ${locator}
    ${price}    Replace String Using Regexp    ${price}    [^\\d.]    , 
    ${price}    Remove String    ${price}    ,    m    k
    ${price}    Remove String    ${price}    +    %
    ${price}    Convert To Number    ${price}    1
    Return From Keyword    ${price}    

    
Select second price model
    [Documentation]    select the second price model
    [Arguments]    ${rawMaterial}
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']} 
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions YTD + ROY MAC']    CP/MAC assumptions YTD + ROY MAC
    Verify all the fields in second price model window
    sleep    2s
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}
    Save the price model
    
Select second price model with currency
    [Documentation]    select the second price model
    [Arguments]    ${rawMaterial}
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${currency}    Set Variable    ${json['currency']}
    Set Global Variable    ${rawMaterial}      
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions YTD + ROY MAC']    CP/MAC assumptions YTD + ROY MAC
    Verify all the fields in second price model window
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}
    Select values in price model dropdown field    //span[text()='Select Supplier Currency']    ${currency}
    Save the price model


Validate the price models displayed
    [Documentation]    Validate the price model tabs displayed
    Page Should Contain Element    //div[contains(@class,'priceModel')]//h6[text()='CP/MAC assumptions AVG full year']    Failed in cp/mac assumptions avg full year validation
    Page Should Contain Element    //div[contains(@class,'priceModel')]//h6[text()='CP/MAC assumptions YTD + ROY MAC']    Failed in cp/mac assumptions avg YTD + ROY MAC validation
    Page Should Contain Element    //div[@class='priceModelSelected']//h6[text()='Regular Adjustment Gliding']    Failed in Regular Adjustment Gliding validation
    Page Should Contain Element    //div[@class='priceModelSelected']//h6[text()='Other Price Model']    Failed in Other price model validation
    Page Should Contain Element    //div[@class='priceModelSelected']//h6[text()='Manual']    Failed in Manual price model validation    
 
Validate the price models displayed for plastic
    [Documentation]    on;ly first price model should display 
    Page Should Contain Element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    Failed in cp/mac assumptions avg full year validation
    Page Should Not Contain Element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions YTD + ROY MAC']    Failed in cp/mac assumptions avg YTD + ROY MAC validation
    Page Should Not Contain Element   //div[@class='priceModelSelected']//h6[text()='Regular Adjustment Gliding']    Failed in Regular Adjustment Gliding validation
    Page Should Not Contain Element    //div[@class='priceModelSelected']//h6[text()='Other Price Model']    Failed in Other price model validation
    Page Should Not Contain Element    //div[@class='priceModelSelected']//h6[text()='Manual']    Failed in Manual price model validation  
 
Verify all the fields in first price model window
    [Documentation]    Verify all the fields in first price model window
    Wait Until Page Contains Element    //div[contains(@class,'rmi-modal-dialog')]
    Page Should Contain Element    //span[text()='Select Price Reference']     Failed in CP/MAC price ref field validation
    Page Should Contain Element    //span[text()='Select Supplier Currency']    Failed in Currency dropdown field validation
    Page Should Contain Button    //button[text()='Cancel']    Failed in validating cancel field button
    Page Should Contain Button    //button[normalize-space(.)='Set price reference']    Failed in validating save button
    
Verify all the fields in second price model window
    [Documentation]    Verify all the fields in first price model window
    Wait Until Page Contains Element    //div[contains(@class,'rmi-modal-dialog')]
    Page Should Contain Element    (//span[text()='Select Price Reference'])[1]    Failed in YTD price ref field validation
    Page Should Contain Element    (//span[text()='Select Price Reference'])[2]    Failed in ROY price ref field validation
    Page Should Contain Element    //span[text()='Select Supplier Currency']    Failed in Currency dropdown field validation
    Page Should Contain Button    //button[text()='Cancel']    Failed in validating cancel field button
    Page Should Contain Button    //button[normalize-space(.)='Set price reference']    Failed in validating save button                
    Page Should Contain Element    //oc-radio[@id='ytd_MM']/label[text()='CP/MAC assumptions']    Failed in CP/MAC assumptions radio button field validation
    Page Should Contain Element    //oc-radio[@id='ytd_MM']/label[text()='Commodity Market Monitor']    Failed in CMM radio button field validation
    # Page Should Contain Element    //oc-radio[@id='ytd_MA']/label[normalize-space(.)='CP/MAC assumptions price development in %']    Failed in CP/MAC assumptions price development radio button field validation

Expand and validate the regular adjustment gliding fields
    [Documentation]    Expand the raw material and validate the reg adj pop-up fields
    ...    and click on cancel button
    Expand or collapse the container    ${rawMaterial}
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Regular Adjustment Gliding']    Regular Adjustment Gliding
    Verify all the fields in regular adjustment gliding
    UD_Click button    //button[text()='Cancel']    Cancel


Select regular adjustment gliding without currency
    [Documentation]    select regular adjustment gliding without currency
    [Arguments]    ${rawMaterial}
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${offsetValue}    Set Variable    ${json['offset']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Regular Adjustment Gliding']    Regular Adjustment Gliding
    Verify all the fields in regular adjustment gliding
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    //span[text()='Select Offset']    ${offsetValue}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}   
    Save the price model


Select regular adjustment gliding with currency
    [Documentation]    select regular adjustment gliding without currency
    [Arguments]    ${rawMaterial}
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${offsetValue}    Set Variable    ${json['offset']}
    ${currency}    Set Variable    ${json['currency']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Regular Adjustment Gliding']    Regular Adjustment Gliding
    Verify all the fields in regular adjustment gliding
    Select values in price model dropdown field    //span[text()='Select Supplier Currency']    ${currency}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    //span[text()='Select Offset']    ${offsetValue}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}   
    Save the price model

Select raw material and regular adjustment gliding without currency
    [Documentation]    Select raw material,add matshare and click on next button
    ...    Select the regular adjustment gliding and click on save
	[Arguments]    ${raw}
	${json}    Get raw material from Json file    ${raw}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${currency}    Set Variable    ${json['currency']}
	Select raw materials and set matshare    ${rawMaterial}         
    Click on save and next button to save raw material
    Validate added raw material and matshare
    Select regular adjustment gliding without currency    ${raw}
    Click on save button to the save calculate rmi

Select raw material and regular adjustment gliding with currency
    [Documentation]    Select raw material,add matshare and click on next button
    ...    Select the regular adjustment gliding and click on save
	[Arguments]    ${raw}
	${json}    Get raw material from Json file    ${raw}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${currency}    Set Variable    ${json['currency']}
	Select raw materials and set matshare    ${rawMaterial}         
    Click on save and next button to save raw material
    Validate added raw material and matshare
    Select regular adjustment gliding with currency    ${raw}
    Click on save button to the save calculate rmi

Select raw material and manual price model for ytd and roy price
    [Documentation]    Select raw material,add matshare and click on next button
    ...    Select the manual pm for ytd+roy split up and click on save
	[Arguments]    ${raw}
	${json}    Get raw material from Json file    ${raw}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
	Select raw materials and set matshare    ${rawMaterial}         
    Click on save and next button to save raw material
    Validate added raw material and matshare
    Select manual price model with YTD and ROY split
    Click on save button to the save calculate rmi

Select raw material and manual price model for full year price
    [Documentation]    Select raw material,add matshare and click on next button
    ...    Select the manual pm for ytd+roy split up and click on save
	[Arguments]    ${raw}
	${json}    Get raw material from Json file    ${raw}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
	Select raw materials and set matshare    ${rawMaterial}         
    Click on save and next button to save raw material
    Validate added raw material and matshare
    Select manual price model with full year price
    Click on save button to the save calculate rmi
    
Verify all the fields in regular adjustment gliding
    [Documentation]    Verify all the fields in regular adjustment gliding
    Wait Until Page Contains Element    //div[contains(@class,'rmi-modal-dialog')]
    Page Should Contain Element    (//span[text()='Select Price Reference'])[1]    Failed in YTD price ref field validation
    Page Should Contain Element    (//span[text()='Select Price Reference'])[2]    Failed in ROY price ref field validation
    Page Should Contain Element    //span[text()='Select Supplier Currency']    Failed in Currency dropdown field validation
    Page Should Contain Button    //button[text()='Cancel']    Failed in validating cancel field button
    Page Should Contain Button    //button[normalize-space(.)='Set price reference']    Failed in validating save button
    Page Should Contain Button    //button[text()='Calculate compare price']    Failed in validaing calc compare price btn
    #Validate month radio button for both last and and next month
    Verify ragular adjustment gliding radio buttons    Use average of last
    Verify ragular adjustment gliding radio buttons    For the next
    Page Should Contain Element    //span[text()='Select Offset']    Failed in Offset dropdown field validation
    Page Should Contain Element    //oc-radio/label[normalize-space(.)='CP/MAC assumptions']   Failed in CP/MAC assumptions price development radio button field validation


Verify all the fields in Bourns price model
    [Documentation]    Verify all the fields in regular adjustment gliding
    Wait Until Page Contains Element    //div[contains(@class,'rmi-modal-dialog')]
    Page Should Contain Element    (//span[text()='Select Price Reference'])[1]    Failed in YTD price ref field validation
    Page Should Contain Element    (//span[text()='Select Price Reference'])[2]    Failed in ROY price ref field validation
    Page Should Contain Element    //span[text()='Select Supplier Currency']    Failed in Currency dropdown field validation
    Page Should Contain Button    //button[text()='Cancel']    Failed in validating cancel field button
    Page Should Contain Button    //button[normalize-space(.)='Set price reference']    Failed in validating save button
    Page Should Contain Button    //button[text()='Calculate compare price']    Failed in validaing calc compare price btn
    Page Should Contain Element    //oc-radio/label[normalize-space(.)='CP/MAC assumptions']   Failed in CP/MAC assumptions price development radio button field validation



Verify all the fields in manual price model
    [Documentation]    Verify all the fields in manual price model
    Wait Until Page Contains Element    //div[contains(@class,'rmi-modal-dialog')]
    Page Should Contain Element    (//calculate-rmi-manual//input[@placeholder='price'])[1]    Failed in YTD price ref field validation
    Page Should Contain Element    (//calculate-rmi-manual//input[@placeholder='price'])[2]    Failed in ROY price ref field validation
    Page Should Contain Element    (//span[text()='select currency'])[1]    Failed in YTD Currency dropdown field validation
    Page Should Contain Element    (//span[text()='select currency'])[2]    Failed in ROY Currency dropdown field validation
    Page Should Contain Element    (//span[text()='select weight unit'])[1]    Failed in YTD Weight unit field validation
    Page Should Contain Element    (//span[text()='select weight unit'])[2]    Failed in ROY YTD Weight unit field validation
    Page Should Contain Button    //button[text()='Cancel']    Failed in validating cancel field button
    Page Should Contain Button    //button[normalize-space(.)='Set price reference']    Failed in validating save button


Select manual price model with YTD and ROY split
    [Documentation]    Select manual price model with YTD and ROY split
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    manual    
    ${ytdPrice}    Set Variable    ${json['ytdPrice']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Manual']    Manual
    Verify all the fields in manual price model
    #Enter the YTD and ROY prices
    Input Text    (//calculate-rmi-manual//input[@placeholder='price'])[1]     ${json['ytdPrice']}
    Input Text    (//calculate-rmi-manual//input[@placeholder='price'])[2]     ${json['royPrice']}
    #Enter the YTD and ROY prices
    Select values in price model dropdown field    (//span[text()='select currency'])[1]     ${json['ytdCurrency']}
    Select values in price model dropdown field    (//span[text()='select currency'])[1]    ${json['royCurrency']}
    #Enter the YTD and ROY weight unit
    Select values in price model dropdown field    (//span[text()='select weight unit'])[1]     ${json['ytdWeightUnit']}
    Select values in price model dropdown field    (//span[text()='select weight unit'])[1]    ${json['royWeightUnit']}
    Save the price model


Select manual price model with full year price
    [Documentation]    Select manual price model with YTD and ROY split
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    manual    
    ${ytdPrice}    Set Variable    ${json['ytdPrice']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Manual']    Manual
    Verify all the fields in manual price model
    #switch to full year price
    UD_Click element    //label[@class='switch']/input    Switch
    #Enter the full year prices
    Input Text    (//calculate-rmi-manual//input[@placeholder='price'])[1]     ${json['ytdPrice']}
    #Enter the full year prices
    Select values in price model dropdown field    (//span[text()='select currency'])[1]     ${json['ytdCurrency']}
    #Enter weight unit for full year price
    Select values in price model dropdown field    (//span[text()='select weight unit'])[1]     ${json['ytdWeightUnit']}
    Save the price model

Verify ragular adjustment gliding radio buttons
    [Arguments]    ${fields}
    @{values}    Create List    1 month    3 months    6 months
    FOR    ${x}    IN    @{values}        
    Page Should Contain Element    //*[contains(text(),'${fields}')]/../oc-radio-group//*[text()='${x}']    Failed in validating ${x} radio button
    log    verified ${fields} for ${x} radio button
    END
    
Select values in price model dropdown field
    [Arguments]    ${locator}    ${value}
    Set Focus To Element    ${locator}
    UD_Click element    ${locator}    dropdown
    Input Text    ${locator}/../..//following::input[1]    ${value}
    UD_Click element   ${locator}/../..//following::label[2]    label
    # UD_Click element    ((${locator}//following::label[text()='${value}'])[1]    label

    
Click on save button to the save calculate rmi
     [Documentation]    Click on Save button and validate the success message
     UD_Click element    //img[@title='save changes']    Save
     Wait for angular loading image    20s 
     Verify the success message    The changes are saved successfully
    
Click on back button to redirect to raw material page
    [Documentation]    Click on back button to redirect to define scope page 
    UD_Click element    //img[@title='back to my scopes']    Back
    # Validate the page should contains the attribute    //li[@id='raw-material']    class	menu-item black active
        
Verify Price model values are restored while changing raw material
    [Documentation]    Verify Price model values are restored while changing raw material
    Verify the success message    Raw Material Selection and Mat. Share allocation has been saved
    Expand or collapse the container    ${rawMaterial}
    # UD_Click element    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::img[1]    image
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Verify all the fields in first price model window
    ${x}    Get Text    //span[text()='Select Price Reference']
    Should Not Be Equal    ${priceRef}    ${x}
    UD_Click button    //button[@class='oc-button-prio-2']     Cancel

Validate extended raw material
    [Documentation]    select the second price model
    [Arguments]    ${multiSelect}
    #Get the details from JSON
    ${json}=    Get raw material from Json file    ${multiSelect}    
    ${rawMaterial}=    Set Variable    ${json['rawMat']}
    ${MatShare}=    Set Variable    ${json['matShare']}
    ${firstPriceModel}=    Set Variable    ${json['firstPrice']}
    Select multiselect raw materials and set matshare   ${multiSelect}    ${rawMaterial}    ${MatShare}
    Click on next button
    Sleep    2s 
    Select first price model    ${rawMaterial}
    Click on save button to the save calculate rmi
    Verify the base and compare price for first price model

    
Validate base compare price rmi total and percent for first price model
    [Documentation]    Validate base and compare price and RMI total and RMI Percent
    Wait Until Page Contains Element    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::img[1]
    
    # ${count}    Get Matching XPath Count    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h5[text()='Base Price']/following::span[2]/b
    # Run Keyword If    ${count}==0
    # ...    Click Element    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::img[1]
    Expand or collapse the container    ${rawMaterial}
    ${basePrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='Base Price']/following::span[2]/b
    ${comPrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='Compare Price']/following::span[5]/b
    ${rmiTotal}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='RMI total']/following::span/oc-tooltip//span[1]
    ${rmiPercent}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='RMI %']/following::span[11]
    # ${rmiPercent}    Remove String    ${rmiPercent}    +    -    %
    # ${rmiPercent}    Convert To Number    ${rmiPercent}    2
    #Get the values from the query
    @{dbVal}    Run first price model query and return the prices
    #Columns in DB Price ref name, BV, BP, CP,rmi otal, rmi percent
    Set Global Variable    ${baseVolume}    ${dbVal[1]}
    ${bpDB}    Set Variable    ${dbVal[2]}
    ${cpDB}    Set Variable    ${dbVal[3]}
    ${rmitotalDB}    Set Variable    ${dbVal[4]}
    ${rmipercentDB}    Set Variable    ${dbVal[5]}
    #Convert to number
    ${bpDB}    Convert To Number    ${bpDB}    2
    ${cpDB}    Convert To Number    ${cpDB}    2
    ${basePrice}    Convert To Number    ${basePrice}    1
    ${comPrice}    Convert To Number    ${comPrice}    1    
    #Price adjusted as per UI format
    ${bpDB}    Price format adjusted as per UI    ${bpDB}
    ${cpDB}    Price format adjusted as per UI    ${cpDB}
    #RMI total formatting as per UI
    ${rmitotalDB}    Price format adjusted as per UI   ${rmitotalDB}
    ${rmipercentDB}    Convert To String    ${rmipercentDB}
    ${rmipercentDB}    Remove String    ${rmipercentDB}    +    %
    ${rmipercentDB}    Convert To Number    ${rmipercentDB}    2
    ${rmipercentDB}    Convert To Number    ${rmipercentDB}    1
    Should Be Equal    ${basePrice}    ${bpDB}    Failed in base price validation
    Should Be Equal    ${comPrice}     ${cpDB}    Failed in compare price validation
    Should Be Equal    ${rmiTotal}     ${rmitotalDB}    Failed in RMI total validation
    Should Be Equal    ${rmiPercent}     ${rmipercentDB}    Failed in RMI percent validation


Validate base compare price rmi total and percent for first price model plastic
    [Documentation]    Validate base and compare price and RMI total and RMI Percent
    Expand or collapse the container    ${rawMaterial}
    ${basePrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='Base Price']/following::span[2]/b
    ${comPrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='Compare Price']/following::span[5]/b
    ${rmiTotal}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='RMI total']/following::span/oc-tooltip//span[1]
    ${rmiPercent}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//*[contains(text(),'${rawMaterial}')]/../following::div[1]//h3[text()='RMI %']/following::span[11]
    # Change the query to plastic
    @{dbVal}    Run first price model query and return the prices
    Set Global Variable    ${baseVolume}    ${dbVal[1]}
    ${bpDB}    Set Variable    ${dbVal[2]}
    ${cpDB}    Set Variable    ${dbVal[3]}
    ${rmitotalDB}    Set Variable    ${dbVal[4]}
    ${rmipercentDB}    Set Variable    ${dbVal[5]}
    #Convert to number
    ${bpDB}    Convert To Number    ${bpDB}    2
    ${cpDB}    Convert To Number    ${cpDB}    2
    ${basePrice}    Convert To Number    ${basePrice}    1
    ${comPrice}    Convert To Number    ${comPrice}    1    
    #Price adjusted as per UI format
    ${bpDB}    Price format adjusted as per UI    ${bpDB}
    ${cpDB}    Price format adjusted as per UI    ${cpDB}
    #RMI total formatting as per UI
    ${rmitotalDB}    Price format adjusted as per UI   ${rmitotalDB}
    ${rmipercentDB}    Convert To String    ${rmipercentDB}
    ${rmipercentDB}    Remove String    ${rmipercentDB}    +    %
    ${rmipercentDB}    Convert To Number    ${rmipercentDB}    2
    ${rmipercentDB}    Convert To Number    ${rmipercentDB}    1
    Should Be Equal    ${basePrice}    ${bpDB}    Failed in base price validation
    Should Be Equal    ${comPrice}     ${cpDB}    Failed in compare price validation
    Should Be Equal    ${rmiTotal}     ${rmitotalDB}    Failed in RMI total validation
    Should Be Equal    ${rmiPercent}     ${rmipercentDB}    Failed in RMI percent validation
    
Price format adjusted as per UI
    [Arguments]    ${rmitotalDB}
    ${tempVal}    Set Variable    ${rmitotalDB}
    ${tempVal}    Convert To Number    ${tempVal}    1
    ${tempVal}    Convert To String    ${tempVal}
    ${tempVal}    Replace String Using Regexp    ${tempVal}    [^\\d.]    ,
    ${tempVal}    Remove String    ${tempVal}    -    ,
    ${count}    Get Length    ${tempVal}
    ${count}    Evaluate    ${count}-2
    ${json}=    Get raw material from Json file    divisor    
    ${divisor}=    Set Variable    ${json['${count}']}
    ${result}    Evaluate    ${rmitotalDB} / ${divisor}
    ${result}    Convert To Number    ${result}    1
    [Return]    ${result}    

Validate the aggregated figure for selected raw materials
    [Documentation]    Validates the aggreagate value of Base volume, RMI total and RMI percent
    ${aggBaseVol}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[1] 
    ${aggRmiTotal}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[2]
    ${aggRmiPercent}    Get RMI total and percent   //rmi-planning-calculate-rmi//div[@class='oc-group-box']//h2     
       
    #Get the base volum from query
    ${baseVolume}    Price format adjusted as per UI   ${baseVolume}
    # Values from the raw material level
    ${rmiTotal}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[4]
    ${rmiPercent}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[5]
    #Validation part
    Should Be Equal    ${baseVolume}    ${aggBaseVol}    Failed in Base volume validation
    Should Be Equal    ${rmiTotal}    ${aggRmiTotal}    Failed in RMI total validation
    Should Be Equal    ${rmiPercent}    ${aggRmiPercent}    Failed in RMI percent validation
    
    
Select first price model and try to save without adding price reference
    [Documentation]    select the first price model and try to save without adding the price references
    ...    Validate the error msg    
    [Arguments]    ${rwMt}
    # ${json}=    Get raw material from Json file    ${rwMt}
    # ${priceRef}=    Set Variable    ${json['firstPrice']}
    Set Global Variable    ${priceRef}
    Expand or collapse the container    ${rwMt}    
    # Wait Until Page Contains Element    //*[@class='calc-rmi-collapse-header']/div[h4[contains(text(),'${rwMt}')]]/..//oc-icon
    # Click Element    //*[@class='calc-rmi-collapse-header']/div[h4[contains(text(),'${rwMt}')]]/..//oc-icon
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Verify all the fields in first price model window
    Sleep    2s            
    Save the price model
    Verify the error message    Please select a price reference.
    UD_Click button    //*[@class='oc-button-prio-2']    Cancel
    Expand or collapse the container    ${rwMt}
    
Validate base compare price rmi total and percent for second price model
    [Documentation]    Validate base and compare price and RMI total and RMI Percent
    Expand or collapse the container    ${rawMaterial}
    ${basePrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[2]
    ${comPrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[3]
    ${rmiTotal}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[4]
    ${rmiPercent}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[5]

    #Get the values from the query
    @{dbVal}    Run second price model query and return the prices
    #Columns in DB Price ref name, BV, BP, CP,ytd price, roy price,rmi otal, rmi percent, tonnage, price effect, fx effect
    Set Global Variable    ${baseVolume}    ${dbVal[1]}       
    ${bpDB}    Set Variable    ${dbVal[2]}
    ${cpDB}    Set Variable    ${dbVal[3]}
    ${rmitotalDB}    Set Variable    ${dbVal[6]}
    ${rmipercentDB}    Set Variable    ${dbVal[7]}
    #Convert to number
    ${bpDB}    Convert To Number    ${bpDB}    2
    ${cpDB}    Convert To Number    ${cpDB}    2
    ${bpDB}    Price format adjusted as per UI   ${bpDB}
    ${cpDB}    Price format adjusted as per UI   ${cpDB}
    ${basePrice}    Convert To Number    ${basePrice}    1
    ${comPrice}    Convert To Number    ${comPrice}    1
    #RMI total formatting as per UI
    ${rmitotalDB}    Price format adjusted as per UI   ${rmitotalDB}
    ${rmipercentDB}    Convert To String    ${rmipercentDB}
    ${rmipercentDB}    Remove String    ${rmipercentDB}    +    %
    ${rmipercentDB}    Convert To Number    ${rmipercentDB}    1
    Should Be Equal    ${basePrice}    ${bpDB}    Failed in base price validation
    Should Be Equal    ${comPrice}     ${cpDB}    Failed in compare price validation
    Should Be Equal    ${rmiTotal}     ${rmitotalDB}    Failed in RMI total validation
    Should Be Equal    ${rmiPercent}     ${rmipercentDB}    Failed in RMI percent validation

Validate the calculated YTD and ROY price for second price model
    [Documentation]    validate the calculated YTD and ROY prices
    ...    validates the prices in collapse header
    Expand or collapse the container    ${rawMaterial}
    Page Should Contain Element    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[3]    5s
    Mouse Over    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[3]
    #Get the values from UI
    ${royPrice}    Get YTD and ROY prices    //div[@class='info-tooltip']/div//span[2]
    ${ytdPrice}    Get YTD and ROY prices    //div[@class='info-tooltip']/div//span[1]
    @{dbVal}    Run second price model query and return the prices
    #Columns in DB Price ref name, BV, BP, CP,ytd price, roy price,rmi otal, rmi percent, tonnage, price effect, fx effect
    ${ytdDB}    Set Variable    ${dbVal[4]}
    ${royDB}    Set Variable    ${dbVal[5]}
    #Rounding offt to 2 digits
    ${ytdDB}    Convert To Number    ${ytdDB}    2
    ${royDB}    Convert To Number    ${royDB}    2
        
    Should Be Equal    ${royPrice}    ${royDB}    msg=Failed in ROY price validation
    Should Be Equal    ${ytdPrice}    ${ytdDB}    msg=Failed in YTD price validation


Validate the compare price split up prices for second price model
    [Documentation]    validate the calculated YTD and ROY splitup 
    ...    validates the prices in Expand header
    #Mouse hover on Compare price and validate the YTD and ROY
    Page Should Contain Element    (//oc-tooltip)[2]    5s
    Mouse Over    (//oc-tooltip)[2]
    #Get the values from UI
    ${royPrice}    Get YTD and ROY prices    //div[@class='info-tooltip']/div//span[4]
    ${ytdPrice}    Get YTD and ROY prices    //div[@class='info-tooltip']/div//span[2]
    @{dbVal}    Run second price model query and return the prices
    #Columns in DB Price ref name, BV, BP, CP,ytd price, roy price,rmi otal, rmi percent, tonnage, price effect, fx effect
    ${ytdDB}    Set Variable    ${dbVal[4]}
    ${royDB}    Set Variable    ${dbVal[5]}
    #Rounding offt to 2 digits
    ${ytdDB}    Convert To Number    ${ytdDB}    2
    ${royDB}    Convert To Number    ${royDB}    2
    Should Be Equal    ${royPrice}    ${royDB}    msg=Failed in ROY price validation
    Should Be Equal    ${ytdPrice}    ${ytdDB}    msg=Failed in YTD price validation


Validate the rmi total split up prices for second price model
    [Documentation]    validate the calculated Price & FX effects splitup
    ...    validates the prices in Expand header
    #Mouse hover on RMi TOtal and validate the FX and Price effect
    Page Should Contain Element    (//oc-tooltip)[3]    5s
    Mouse Over    (//oc-tooltip)[3]
    Mouse Over    (//oc-tooltip)[3]
    #Get the values from UI
    ${priceEffect}    Get YTD and ROY prices with one decimal values     //div[@class='info-tooltip']/span/span[2]
    ${fxEffect}    Get YTD and ROY prices with one decimal values     //div[@class='info-tooltip']/span/span[4]
    @{dbVal}    Run second price model query and return the prices
    #Columns in DB Price ref name, BV, BP, CP,ytd price, roy price,rmi otal, rmi percent, tonnage, price effect, fx effect
    ${priceEfDB}    Set Variable    ${dbVal[9]}
    ${fxEffextDB}    Set Variable    ${dbVal[10]}
    #Rounding off to 1 digits
    ${priceEfDB}    Price format adjusted as per UI    ${priceEfDB}
    ${fxEffextDB}    Price format adjusted as per UI    ${fxEffextDB}
    #Rounding to one decimal point
    ${priceEffect}    Convert To Number    ${priceEffect}    1
    ${fxEffect}    Convert To Number    ${fxEffect}    1    
    Should Be Equal    ${priceEffect}    ${priceEfDB}    msg=Failed in Price Effect price validation
    Should Be Equal    ${fxEffect}    ${fxEffextDB}    msg=Failed in FX Effect price validation
    
    #Validate the Price and FX effect for RMI total at aggregate level
    Mouse Over    (//oc-tooltip)[1]/div
    ${priceEffectAgg}    Get YTD and ROY prices with one decimal values     //div[@class='info-tooltip']/span/span[2]
    ${fxEffectAgg}    Get YTD and ROY prices with one decimal values     //div[@class='info-tooltip']/span/span[4]
     #Rounding to one decimal point
    ${priceEffectAgg}    Convert To Number    ${priceEffectAgg}    1
    ${fxEffectAgg}    Convert To Number    ${fxEffectAgg}    1 
    Should Be Equal    ${priceEffectAgg}    ${priceEfDB}    msg=Failed in Price Effect price validation
    Should Be Equal    ${fxEffectAgg}    ${fxEffextDB}    msg=Failed in FX Effect price validation

Validate base compare price rmi total and percent for regular adjustmnet gliding
    [Documentation]    Validate base and compare price and RMI total and RMI Percent
    Expand or collapse the container    ${rawMaterial}
    ${basePrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[2]
    ${comPrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[3]
    ${rmiTotal}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[4]
    ${rmiPercent}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[5]

    #Get the values from the query
    @{dbVal}    Run second price model query and return the prices
    #Columns in DB Price ref name, BV, BP, CP,ytd price, roy price,rmi otal, rmi percent, tonnage, price effect, fx effect
    Set Global Variable    ${baseVolume}    ${dbVal[1]}       
    ${bpDB}    Set Variable    ${dbVal[2]}
    ${cpDB}    Set Variable    ${dbVal[3]}
    ${rmitotalDB}    Set Variable    ${dbVal[6]}
    ${rmipercentDB}    Set Variable    ${dbVal[7]}
    #Convert to number
    ${bpDB}    Convert To Number    ${bpDB}    2
    ${cpDB}    Convert To Number    ${cpDB}    2
    #RMI total formatting as per UI
    ${rmitotalDB}    Price format adjusted as per UI   ${rmitotalDB}
    ${rmipercentDB}    Convert To String    ${rmipercentDB}
    ${rmipercentDB}    Remove String    ${rmipercentDB}    +    %
    ${rmipercentDB}    Convert To Number    ${rmipercentDB}    1
    Should Be Equal    ${basePrice}    ${bpDB}    Failed in base price validation
    Should Be Equal    ${comPrice}     ${cpDB}    Failed in compare price validation
    Should Be Equal    ${rmiTotal}     ${rmitotalDB}    Failed in RMI total validation
    Should Be Equal    ${rmiPercent}     ${rmipercentDB}    Failed in RMI percent validation

Validate base compare price rmi total and percent for Manual price model
    [Documentation]    Validate base and compare price and RMI total and RMI Percent
    Expand or collapse the container    ${rawMaterial}
    ${basePrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[2]
    ${comPrice}    Get price and return the digits    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[3]
    ${rmiTotal}    Get RMI total and percent    //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[4]
    ${rmiPercent}    Get RMI total and percent   //*[@class='calc-rmi-collapse-header']//h4[contains(text(),'${rawMaterial}')]/following::div[@class='flex-container'][2]/div[5]

    #Get the values from the query
    @{dbVal}    Run second price model query and return the prices
    #Columns in DB Price ref name, BV, BP, CP,ytd price, roy price,rmi otal, rmi percent, tonnage, price effect, fx effect
    Set Global Variable    ${baseVolume}    ${dbVal[1]}       
    ${bpDB}    Set Variable    ${dbVal[2]}
    ${cpDB}    Set Variable    ${dbVal[3]}
    ${rmitotalDB}    Set Variable    ${dbVal[6]}
    ${rmipercentDB}    Set Variable    ${dbVal[7]}
    #Convert to number
    ${bpDB}    Convert To Number    ${bpDB}    2
    ${cpDB}    Convert To Number    ${cpDB}    2
    #RMI total formatting as per UI
    ${rmitotalDB}    Price format adjusted as per UI   ${rmitotalDB}
    ${rmipercentDB}    Convert To String    ${rmipercentDB}
    ${rmipercentDB}    Remove String    ${rmipercentDB}    +    %
    ${rmipercentDB}    Convert To Number    ${rmipercentDB}    1
    Should Be Equal    ${basePrice}    ${bpDB}    Failed in base price validation
    Should Be Equal    ${comPrice}     ${cpDB}    Failed in compare price validation
    Should Be Equal    ${rmiTotal}     ${rmitotalDB}    Failed in RMI total validation
    Should Be Equal    ${rmiPercent}     ${rmipercentDB}    Failed in RMI percent validation


Get YTD and ROY prices
    [Documentation]    get YTD and ROY prices
    [Arguments]    ${locator}
    ${price}    Get Text            ${locator}
    ${price}    Replace String Using Regexp    ${price}    [^\\d.]    ,
    ${price}    Remove String    ${price}    ,
    ${price}    Convert To Number    ${price}    2
    Return From Keyword    ${price}    
    
    
Get YTD and ROY prices with one decimal values
    [Documentation]    get YTD and ROY prices
    [Arguments]    ${locator}
    ${price}    Get Text            ${locator}
    ${price}    Replace String Using Regexp    ${price}    [^\\d.]    ,
    ${price}    Remove String    ${price}    ,
    ${price}    Convert To Number    ${price}    2
    Return From Keyword    ${price}   
    
Verify the Bourns price is within Other price model
    [Documentation]    Verify the Bourns price models
    Expand or collapse the container    ${rawMaterial}
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Other Price Model']    Other Price Model
    Wait Until Page Contains Element    //div[@class='rmi-modal-dialog']    5s
    Page Should Contain Element    //div[@class='rmi-modal-dialog']//h6[text()='Bourns']    Failed in validating Bourns price model
    UD_Click button    //button[text()='Cancel']    cancel
        
Validate the compare price split up for regular adjustment gliding without currency
    [Documentation]    Update the regular adjustment gliding and click on save
	[Arguments]    ${raw}
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${offsetValue}    Set Variable    ${json['offset']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Regular Adjustment Gliding']    Regular Adjustment Gliding
    Verify all the fields in regular adjustment gliding
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    //span[text()='Select Offset']    ${offsetValue}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}   
    #Click on calculate button and validate the splitup
    UD_Click element    //button[text()='Calculate compare price']    Calculate compare price
    @{web}=    Get WebElements    //div[@class='gliding-timeline']//li
    FOR    ${ELEMENT}    IN     @{web}
    ${tmpData}=    Get Text    ${ELEMENT}
    Log To Console    ${tmpData}
    END
    Save the price model
    Click on save button to the save calculate rmi
    
Validate the compare price split up for regular adjustment gliding with currency
    [Documentation]    Select raw material,add matshare and click on next button
    ...    Select the regular adjustment gliding and click on save
	[Arguments]    ${raw}
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${offsetValue}    Set Variable    ${json['offset']}
    ${currency}    Set Variable    ${json['currency']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Regular Adjustment Gliding']    Regular Adjustment Gliding
    Verify all the fields in regular adjustment gliding
    Select values in price model dropdown field    //span[text()='Select Supplier Currency']    ${currency}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    //span[text()='Select Offset']    ${offsetValue}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}   
    #Click on calculate button and validate the splitup
    UD_Click element    //button[text()='Calculate compare price']    Calculate compare price
    @{web}=    Get WebElements    //div[@class='gliding-timeline']//li
    FOR    ${ELEMENT}    IN     @{web}
    ${tmpData}=    Get Text    ${ELEMENT}
    Log To Console    ${tmpData}
    END
    Save the price model
    Click on save button to the save calculate rmi
 
Select bourns PM without currency
    [Documentation]    select bourns price model without currency
    [Arguments]    ${rawMaterial}
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${offsetValue}    Set Variable    ${json['offset']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Other Price Model']    Other Price Model
    Wait Until Element Is Visible    //div[@class='rmi-modal-dialog']    10s
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Bourns']    Bourns
    Verify all the fields in Bourns price model
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    //span[text()='Select Offset']    ${offsetValue}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}   
    Save the price model

Select bourns PM with currency
    [Documentation]    select bourns price model with currency
    [Arguments]    ${rawMaterial}
    #Get the YTD and ROY from Json
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${offsetValue}    Set Variable    ${json['offset']}
    ${currency}    Set Variable    ${json['currency']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Other Price Model']    Other Price Model
    Wait Until Element Is Visible    //div[@class='rmi-modal-dialog']    10s
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Bourns']    Bourns
    Verify all the fields in Bourns price model
    Select values in price model dropdown field    //span[text()='Select Supplier Currency']    ${currency}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    //span[text()='Select Offset']    ${offsetValue}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}   
    Save the price model

Validate the compare price split up for bourns price model without currency
    [Documentation]    Update the regular adjustment gliding and click on save
	[Arguments]    ${raw}
    ${json}=    Get raw material from Json file    ${rawMaterial}    
    ${rawMaterial}    Set Variable    ${json['rawMat']}
    ${ytdPriceRef}    Set Variable    ${json['secondYTD']}
    ${royPriceRef}    Set Variable    ${json['secondROY']}
    ${offsetValue}    Set Variable    ${json['offset']}
    Expand or collapse the container    ${rawMaterial}
    Validate the price models displayed
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Other Price Model']    Other Price Model
    Wait Until Element Is Visible    //div[@class='rmi-modal-dialog']    10s
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Bourns']    Bourns
    Verify all the fields in Bourns price model
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])[1]     ${ytdPriceRef}
    Select values in price model dropdown field    //span[text()='Select Offset']    ${offsetValue}
    Select values in price model dropdown field    (//span[text()='Select Price Reference'])    ${royPriceRef}   
    #Click on calculate button and validate the splitup
    UD_Click element    //button[text()='Calculate compare price']    Calculate compare price
    #add code to validate the Splitup and compare prices
    # @{web}=    Get WebElements    //div[@class='gliding-timeline']//li
    # :FOR    ${ELEMENT}    IN     @{web}
    # \    ${tmpData}=    Get Text    ${ELEMENT}
    # \    Log To Console    ${tmpData}
    Save the price model
    Click on save button to the save calculate rmi

Select first price model for steel general planning
    [Documentation]    select the first price model
    [Arguments]    ${rwMt}
    ${json}=    Get raw material from Json file    ${rwMt}
    ${priceRef}=    Set Variable    ${json['basicSteelPF']}
    Set Global Variable    ${priceRef}    
    # Expand the flat steel raw material
    Expand or collapse the container    ${rwMt}
    @{subComp}    Create List    Alloy surcharge    Basic steel    Scrap surcharge
    FOR    ${ELEMENT}    IN    @{subComp}
    UD_Click element    //*[@class='oc-group-box']//calculate-rmi-steel-general-planning//h4[contains(text(),'${ELEMENT}')]/preceding::div[1]    Expand steel sub component
    # \    Validate the price models displayed -- other price model is not relevant
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Verify all the fields in first price model window
    Select values in price model dropdown field    //span[text()='Select Price Reference']    ${json['basicSteelPF']}
    Wait Until Page Contains Element    //div[@class='selected-list']//span[contains(text(),'${priceRef}')]
    #add aboluste adder percentage
    # \    Select values in price model dropdown field    //span[text()='Select Regional Price Percentage']    ${json['adder']}
    Sleep    2s            
    Save the price model
    UD_Click element    //*[@class='oc-group-box']//calculate-rmi-steel-general-planning//h4[contains(text(),'${ELEMENT}')]/preceding::div[1]    Expand steel sub component
    log    Selected first price model for ${ELEMENT}
    END
 
Click on Lock icon
    [Documentation]    Click on Lock icon
    Wait Until Page Contains Element    //oc-icon/img[@title='Fix compare price']    5s
    Sleep    2s
    UD_Click element    //oc-icon/img[@title='Fix compare price']
    Wait Until Page Contains Element    //div[@class='modal-content']    5s  
    UD_Click button    //div[@class='modal-footer']/button[@type='button' and text()='Ok']
    Verify the success message    Compare price for all raw materials was fixed successfully  

Click on Unlock icon
    [Documentation]    Click on Unlock icon
    Sleep     5s 
    Wait Until Element Is Visible    //oc-icon/img[@title='Unfix compare price']    5s
    UD_Click element    //oc-icon/img[@title='Unfix compare price']   
    Wait Until Page Contains Element    //div[@class='modal-content']    5s
    UD_Click button    //button[@type='button' and text()='Ok']
    Verify the success message    Compare price for all raw materials was unfixed successfully

Edit Base Price
    [Documentation]    Click on Edit icon
    Sleep     3s 
    Wait Until Element Is Visible    //*[@id="edit"]/img[@title='edit Base price']    5s  
    UD_Click element    //*[@id="edit"]/img[@title='edit Base price']   Edit button
    Input Text    //input[@type='text']    2000
    Wait Until Element Is Visible    //oc-icon[@iconname='ICN_16_SAVE']/img    5s  
    UD_Click element    //oc-icon[@iconname='ICN_16_SAVE']/img
    Sleep    5s    
    Wait for angular loading image    10
    
Neutralize the Fx effect
    [Documentation]    Neutralize the Fx effect
    Sleep    3s
    Wait Until Element Is Visible    //oc-icon[@iconname='ICN_24_FXEFFECT_DENEUTRAL']/img    5s  
    UD_Click element    //oc-icon[@iconname='ICN_24_FXEFFECT_DENEUTRAL']/img
    Wait Until Page Contains Element    //div[@class='modal-content']    5s
    UD_Click element      //div[@class='modal-footer']/button[@type='button' and text()='Ok']  
    Verify the success message    The fx effect is set to 0.

De-Neutralize the Fx effect
    [Documentation]    De-Neutralize the Fx effect
    Sleep    3s    
    UD_Click element    //oc-icon[@iconname='ICN_24_FXEFFECT_NEUTRAL']/img
    Wait Until Page Contains Element    //div[@class='modal-content']    5s
    UD_Click element    //div[@class='modal-footer']/button[@type='button' and text()='Ok']
    Verify the success message    The fx effect is considered
    
GS/MAC assumptions development in %
    [Documentation]    GS/MAC asumptions development in %
     #[Arguments]
    #${json}=    Get raw material from Json file    ${rwMt}
    #${priceRef}=    Set Variable    ${json['firstPrice']}
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='GS/MAC assumptions development in %']   GS/MAC assumptions development in %
    #Verify all the fields in GS/MAC assumptions development in % window
    Select values in price model dropdown field       //div[@class='c-btn'] /span [text()='Select Price Reference']   ${priceRef}
    Select values in price model dropdown field      //div[@class='c-btn'] /span [text()='Select Supplier Currency']   ${currency}
    UD_Click element    //button[normalize-space(.)='Set price reference']    Set price reference
    
Other Price model
    [Documentation]    Other Price model
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Other Price Model']    Other price model
    UD_Click element    //div[@class='priceModelSelected']//h6[text()='Bourns']    Other price model
    Select values in price model dropdown field    //div[@class='c-btn'] /span [text()='Select Supplier Currency']    EUR
    Select values in price model dropdown field    //*[@id="app-content"]/rmi-main/rmi-modal-placeholder/bourns-price-model/div/div/div[2]/div[2]/div[2]/angular2-multiselect/div/div[1]/div      LME - London metal exchange | LME Aluminium Cash | USD | MT
    UD_Click element    //div[@class='c-btn']/span[text()='Select Offset']    0Months
     
Click Back to raw material screen
    [Documentation]    Back to raw material screen
    sleep    2s
    UD_Click element    //*[@id='raw-material']/a    navigate to raw material screen

Get the aggregated value
    ${aggBaseVol}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[1] 
    ${aggRmiTotal}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[2]
    ${aggRmiPercent}    Get RMI total and percent   //rmi-planning-calculate-rmi//div[@class='oc-group-box']//h2 
    Set Global Variable    ${aggBaseVol}
    Set Global Variable    ${aggRmiTotal}
    Set Global Variable    ${aggRmiPercent}
 
Validate the prices after changing mat share
    [Documentation]    validates prices changes when changing raw materal
    ...    matshare or mat fields
    # Get the aggregated value
    ${actualaggBaseVol}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[1] 
    ${actualaggRmiTotal}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[2]
    ${actualaggRmiPercent}    Get RMI total and percent   //rmi-planning-calculate-rmi//div[@class='oc-group-box']//h2 
    Should Be Equal    ${aggBaseVol}    ${actualaggBaseVol}    Failed in Base volume validation
    Should Not Be Equal    ${aggRmiTotal}    ${actualaggRmiTotal}    Failed in Base volume validation
    Should Not Be Equal    ${aggRmiPercent}    ${actualaggRmiPercent}    Failed in Base volume validation
    
Validate the prices after changing mat fields
    [Documentation]    validates prices should be same after removing and addin the same matfield
    ...    matshare or mat fields
    # Get the aggregated value
    ${actualaggBaseVol}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[1] 
    ${actualaggRmiTotal}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[2]
    ${actualaggRmiPercent}    Get RMI total and percent   //rmi-planning-calculate-rmi//div[@class='oc-group-box']//h2 
    Should not Be Equal    ${aggBaseVol}    ${actualaggBaseVol}    Failed in Base volume validation
    # Should not Be Equal    ${aggRmiTotal}    ${actualaggRmiTotal}    Failed in RMI total validation
    # Should not Be Equal    ${aggRmiPercent}    ${actualaggRmiPercent}    Failed in RMI percentage validation

Validate the prices should be same if no changes
    [Documentation]    validates prices should be same if no changes happen
    ...    by navigating the pages
    # Get the aggregated value
    ${actualaggBaseVol}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[1] 
    ${actualaggRmiTotal}    Get RMI total and percent    (//rmi-planning-calculate-rmi//div[@class='oc-group-box']//oc-h2/div)[2]
    ${actualaggRmiPercent}    Get RMI total and percent   //rmi-planning-calculate-rmi//div[@class='oc-group-box']//h2 
    Should Be Equal    ${aggBaseVol}    ${actualaggBaseVol}    Failed in Base volume validation
    Should Be Equal    ${aggRmiTotal}    ${actualaggRmiTotal}    Failed in RMI total validation
    Should Be Equal    ${aggRmiPercent}    ${actualaggRmiPercent}    Failed in RMI percentage validation

Select first price model for steel part no planning
    [Documentation]    select the first price model for basic and alloy
    [Arguments]    ${rwMt}
    ${json}=    Get raw material from Json file    ${rwMt}
    ${priceRef}=    Set Variable    ${json['basicSteelPF']}
    Set Global Variable    ${priceRef}    
    # Expand the flat steel raw material
    Expand or collapse the container    ${rwMt}
    @{subComp}    Create List    Alloy Surcharge    Basic Steel
    FOR    ${ELEMENT}    IN    @{subComp}
    #expand the sub components, basic, alloy or surchage
    UD_Click element    //h4[text()='${ELEMENT}']//preceding::oc-icon[1]    Expand steel sub component
    # Expand the selected steel price references
    UD_Click element    //h4[text()='${ELEMENT}']//following::oc-icon[1]    Expand steel price references
    Set Focus To Element    //div[@class='priceModelDeSelected']//h6[text()='CP/MAC assumptions AVG full year'] 
    #Open first price model and save
    UD_Click element    //div[@class='priceModelDeSelected']//h6[text()='CP/MAC assumptions AVG full year']    CP/MAC assumptions AVG full year
    Sleep    2s            
    Save the price model
    Click on save button to the save calculate rmi
    log    Selected first price model for ${ELEMENT}
    END

Select manual price model for surcharge
    [Documentation]    select manual price model for surcharge
    # Expand the selected steel price references
    UD_Click element    //h4[text()='Scrap Surcharge']//preceding::oc-icon[1]    Expand steel sub component
    UD_Click element    //h4[text()='Scrap Surcharge']//following::oc-icon[1]    Expand steel price references
    Set Focus To Element    //div[@class='priceModelDeSelected']//h6[text()='Manual'] 
    #Open first price model and save
    UD_Click element    //div[@class='priceModelDeSelected']//h6[text()='Manual']    Manual price reference
    Sleep    2s            
    # Save the price model
    UD_Click button    //button[normalize-space(.)='Set price']    Set price button
    Sleep    4s
    Click on save button to the save calculate rmi


Select GS/MAC price model for steel part no planning
    [Documentation]    select the second price model for basic and alloy
    [Arguments]    ${rwMt}
    ${json}=    Get raw material from Json file    ${rwMt}
    ${priceRef}=    Set Variable    ${json['basicSteelPF']}
    Set Global Variable    ${priceRef}    
    # Expand the flat steel raw material
    Expand or collapse the container    ${rwMt}
    @{subComp}    Create List    Alloy Surcharge    Basic Steel
    FOR    ${ELEMENT}    IN    @{subComp}
    #expand the sub components, basic, alloy or surchage
    UD_Click element    //h4[text()='${ELEMENT}']//preceding::oc-icon[1]    Expand steel sub component
    # Expand the selected steel price references
    UD_Click element    //h4[text()='${ELEMENT}']//following::oc-icon[1]    Expand steel price references
    Set Focus To Element    //div[@class='priceModelDeSelected']//h6[text()='GS/MAC assumptions development in %'] 
    #Open first price model and save
    UD_Click element    //div[@class='priceModelDeSelected']//h6[text()='GS/MAC assumptions development in %']    GS/MAC assumptions development in %
    Sleep    2s            
    Save the price model
    Click on save button to the save calculate rmi
    log    Selected second price model for ${ELEMENT}
    END