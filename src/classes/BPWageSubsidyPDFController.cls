public with sharing class BPWageSubsidyPDFController 
	extends BPCommunicationController 
{
    public BPWageSubsidyPDFController() 
    {
    	Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=WageSusbidyPreview.pdf');  
 		  	
    }
}