/**
 * Created by OFFICE2 on 21/08/2016.
 */

public without sharing class DMLAsSystem
{
    public static void deleteSObject(sObject obj)
    {
        delete obj;
    }

    public static void insertsObject(sObject obj)
    {
        insert obj;
    }
}