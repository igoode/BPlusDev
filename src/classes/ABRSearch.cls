public class ABRSearch 
{ 
    public String getABN(Business__c business)
    {
        String namespace = 'http://abr.business.gov.au/ABRXMLSearch/';
        String queryString = 'name={0}&postcode=&legalName=&tradingName=' + getStateQueryString(business) + '&authenticationGuid={1}&searchWidth=&minimumScore={2}';
        String[] args = new String[]{EncodingUtil.urlEncode(business.Name, 'UTF-8'), '701c0e86-9196-44af-97cb-f297912ccc08', '100'};        
        queryString = String.format(queryString, args);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(namespace + 'AbrXmlSearch.asmx/ABRSearchByNameAdvancedSimpleProtocol?' + queryString);
        request.setMethod('GET');

        HttpResponse response = (new Http()).send(request);
        if (response.getStatusCode() != 200)
        {
            throw new BPException('Request failed');
        }
System.debug(response.getBody());
        Dom.Document docum = response.getBodyDocument();
        Dom.XMLNode rootNode = docum.getRootElement();
        Dom.XMLNode responseNode = rootNode.getChildElement('response', namespace);
        String recordCount = responseNode.getChildElement('searchResultsList', namespace).getChildElement('numberOfRecords', namespace).getText();
        if(recordCount == '1')
        {
            Dom.XMLNode abnNode = responseNode.getChildElement('searchResultsList', namespace).getChildElement('searchResultsRecord', namespace).getChildElement('ABN', namespace);
            if(abnNode.getChildElement('identifierStatus', namespace).getText() == 'Active')
            {
                business.ABN__c = abnNode.getChildElement('identifierValue', namespace).getText();
                return null;
            }
        }
        else if(recordCount != '0')
        {
            return 'Multiple ABN records found for employer name, a manual search will need to be done.';
        }
        return 'ABN not found';
    }

    public String getAccountNames(Account acc, String abn)
    {
        String namespace = 'http://abr.business.gov.au/ABRXMLSearch/';
        String queryString = 'searchString={0}&includeHistoricalDetails=N&authenticationGuid={1}';
        String[] args = new String[]{abn, '48f8fdc5-8ddc-44b8-9dc4-5757e1c1a13b'};        
        queryString = String.format(queryString, args);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(namespace + 'AbrXmlSearch.asmx/ABRSearchByABN?' + queryString);
        request.setMethod('GET');

        HttpResponse response = (new Http()).send(request);
        if (response.getStatusCode() != 200)
        {
            throw new BPException('Request failed');
        }
System.debug(response.getBody());
        Dom.Document docum = response.getBodyDocument();
        Dom.XMLNode rootNode = docum.getRootElement();
        Dom.XMLNode responseNode = rootNode.getChildElement('response', namespace);

        if (responseNode.getChildElement('exception', namespace) != null)
        {   
            return responseNode.getChildElement('exception', namespace).getChildElement('exceptionDescription', namespace).getText();
        }
        Dom.XMLNode entityNode = responseNode.getChildElement('businessEntity', namespace);
        //acc.ABN__c = entityNode.getChildElement('ABN', namespace).getChildElement('identifierValue', namespace).getText();
        acc.Name = toCamelCase(entityNode.getChildElement('mainName', namespace).getChildElement('organisationName', namespace).getText());
        //acc.Trading_Name__c = entityNode.getChildElement('mainTradingName', namespace).getChildElement('organisationName', namespace).getText();    
        
        System.debug(acc)  ;
        return null;
    }

    public String toCamelCase(String s)
    {
        if(s == null)
        {
            return s;
        }
        List<String> newString = new List<String>();
        for(String part : s.split(' '))
        {
            if (!part.contains('.'))
            {
                part = part.toLowerCase().capitalize();
            }
            newString.add(part);
        }
        return String.join(newString, ' ');
    }

    private String getStateQueryString(Business__c business)
    {
        String s = '&NSW=&SA=&ACT=&VIC=&WA=&NT=&QLD=&TAS=';
        /*if (business.State__c != null)
        {
             return s.replace(('&' + business.State__c + '='), ('&' + business.State__c + '=Y'));
        }*/
        return s;        
    }
}