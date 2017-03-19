public class ABRSearch 
{
    private static ABR_Search__c searchSettings = ABR_Search__c.getOrgDefaults();

    public static String getABN(Business__c business)
    {
        String namespace = searchSettings.URL__c;
        String queryString = 'name={0}&postcode=&legalName=Y&businessName=Y&tradingName=Y' + getStateQueryString(business.State__c) + '&authenticationGuid={1}&searchWidth=&minimumScore={2}&maxSearchResults=5';
        String[] args = new String[]{EncodingUtil.urlEncode(business.Name, 'UTF-8'), searchSettings.Key__c, String.valueOf(searchSettings.Minimum_Score__c.intValue())};
        queryString = String.format(queryString, args);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(namespace + searchSettings.URL_Path__c + '?' + queryString);
        request.setMethod('GET');
        HttpResponse response = (new Http()).send(request);
        if (response.getStatusCode() != 200)
        {
            throw new BPException('Request failed');
        }
//System.debug(response.getBody());
        Dom.XMLNode rootNode = response.getBodyDocument().getRootElement();
        Dom.XMLNode searchResultsNode = rootNode.getChildElement('response', namespace).getChildElement('searchResultsList', namespace);
        String recordCount = searchResultsNode.getChildElement('numberOfRecords', namespace).getText();
        String result = 'ABN not found';
        if(recordCount == '0')
        {
            return result;
        }
        for(Dom.XMLNode resultNode : searchResultsNode.getChildElements())
        {
            if(resultNode.getName() == 'searchResultsRecord')
            {
                Dom.XMLNode abnNode = resultNode.getChildElement('ABN', namespace);
                if(abnNode.getChildElement('identifierStatus', namespace).getText() == 'Active')
                {
                    result = abnNode.getChildElement('identifierValue', namespace).getText();
                    break;
                }
            }
        }
        return result;
    }

    public static List<ABRResult> getABN(String busName)
    {
        String namespace = searchSettings.URL__c;
        String queryString = 'name={0}&postcode=&legalName=Y&businessName=Y&tradingName=Y' + getStateQueryString(null) + '&authenticationGuid={1}&searchWidth=&minimumScore={2}&maxSearchResults=100';
        String[] args = new String[]{EncodingUtil.urlEncode(busName, 'UTF-8'), searchSettings.Key__c, String.valueOf(searchSettings.Minimum_Score__c.intValue())};
        queryString = String.format(queryString, args);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(namespace + searchSettings.URL_Path__c + '?' + queryString);
        request.setMethod('GET');
        request.setTimeout(20000);
        HttpResponse response = (new Http()).send(request);
                    if (response.getStatusCode() != 200)
        {
            throw new BPException('Request failed');
        }
//System.debug(response.getBody());
        Dom.XMLNode rootNode = response.getBodyDocument().getRootElement();
        Dom.XMLNode searchResultsNode = rootNode.getChildElement('response', namespace).getChildElement('searchResultsList', namespace);
        String recordCount = searchResultsNode.getChildElement('numberOfRecords', namespace).getText();

        List<ABRResult> results = new List<ABRResult>();
        if(recordCount == '0')
        {
            return results;
        }
        for(Dom.XMLNode resultNode : searchResultsNode.getChildElements())
        {
            String name = null;
            String abn = null;
            if(resultNode.getName() == 'searchResultsRecord')
            {
                Dom.XMLNode abnNode = resultNode.getChildElement('ABN', namespace);
                if(abnNode.getChildElement('identifierStatus', namespace).getText() != 'Active')
                {
                    continue;
                }
                abn = abnNode.getChildElement('identifierValue', namespace).getText();
                Dom.XMLNode nameNode = resultNode.getChildElement('legalName', namespace);
                if(nameNode != null)
                {
                    name = nameNode.getChildElement('fullName', namespace).getText();
                }
                else
                {
                    nameNode = resultNode.getChildElement('mainTradingName', namespace);
                    if(nameNode == null)
                    {
                        nameNode = resultNode.getChildElement('businessName', namespace);
                        if(nameNode == null)
                        {
                            nameNode = resultNode.getChildElement('mainName', namespace);
                        }
                    }
                    if(nameNode != null)
                    {
                        name = nameNode.getChildElement('organisationName', namespace).getText();
                    }
                }
                if(name != null)
                {
                    Dom.XMLNode addressNode = resultNode.getChildElement('mainBusinessPhysicalAddress', namespace);
                    String state = addressNode.getChildElement('stateCode', namespace).getText();
                    String postcode = addressNode.getChildElement('postcode', namespace).getText();
                    results.add(new ABRResult(name, abn, state, postcode));
                }
            }
        }
        return results;
    }

//    public static String getAccountNames(Account acc, String abn)
//    {
//        //String namespace = 'http://abr.business.gov.au/ABRXMLSearch/';
//        String namespace = searchSettings.URL__c;
//        String queryString = 'searchString={0}&includeHistoricalDetails=N&authenticationGuid={1}';
//        //String[] args = new String[]{abn, '48f8fdc5-8ddc-44b8-9dc4-5757e1c1a13b'};
//        String[] args = new String[]{abn, searchSettings.Key__c};
//        queryString = String.format(queryString, args);
//        HttpRequest request = new HttpRequest();
//        request.setEndpoint(namespace + 'AbrXmlSearch.asmx/ABRSearchByABN?' + queryString);
//        request.setMethod('GET');
//
//        HttpResponse response = (new Http()).send(request);
//        if (response.getStatusCode() != 200)
//        {
//            throw new BPException('Request failed');
//        }
//System.debug(response.getBody());
//        Dom.Document docum = response.getBodyDocument();
//        Dom.XMLNode rootNode = docum.getRootElement();
//        Dom.XMLNode responseNode = rootNode.getChildElement('response', namespace);
//
//        if (responseNode.getChildElement('exception', namespace) != null)
//        {
//            return responseNode.getChildElement('exception', namespace).getChildElement('exceptionDescription', namespace).getText();
//        }
//        Dom.XMLNode entityNode = responseNode.getChildElement('businessEntity', namespace);
//        //acc.ABN__c = entityNode.getChildElement('ABN', namespace).getChildElement('identifierValue', namespace).getText();
//        acc.Name = toCamelCase(entityNode.getChildElement('mainName', namespace).getChildElement('organisationName', namespace).getText());
//        //acc.Trading_Name__c = entityNode.getChildElement('mainTradingName', namespace).getChildElement('organisationName', namespace).getText();
//
//        System.debug(acc)  ;
//        return acc.Name;
//    }

    public static String toCamelCase(String s)
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

    public static String getStateQueryString(String state)
    {
        Map<String, String> states = new Map<String, String>{'NSW'=>'&NSW=', 'SA'=>'&SA=', 'ACT'=>'&ACT=', 'VIC'=>'&VIC=', 'WA'=>'&WA=', 'NT'=>'&NT=', 'QLD'=>'&QLD=', 'TAS'=>'&TAS='};
        if(String.isBlank(state) || !states.containsKey(state.toUpperCase()))
        {
            return String.join(states.values(), 'Y');
        }
        state = state.toUpperCase();
        for(String s : states.keySet())
        {
            states.put(s, '&' + s + '=' + (s == state? 'Y' : 'N'));
        }
        return String.join(states.values(), '');
    }

    public class ABRResult
    {
        public ABRResult(String name, String abn, String state, String postcode)
        {
            this.Name = name;
            this.ABN = abn;
            this.State = state;
            this.Postcode = postcode;
        }

        public String Name
        {
            get;
            private set;
        }

        public String ABN
        {
            get;
            private set;
        }

        public String State
        {
            get;
            private set;
        }

        public String Postcode
        {
            get;
            private set;
        }
    }
}