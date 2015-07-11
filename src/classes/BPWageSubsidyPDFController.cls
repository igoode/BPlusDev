public with sharing class BPWageSubsidyPDFController 
	extends BPWageSubsidyController 
{
    public BPWageSubsidyPDFController() 
    {
    	Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=WageSusbidyPreview.pdf');  
 		  	
    }
}