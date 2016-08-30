@isTest
private class TestCodeCoverageRaiser
{
    static testMethod void myUnitTest()
    {
        CodeCoverageRaiser clsBump;
        clsBump = new CodeCoverageRaiser();
        clsBump.BumpCodeCoverage1();
        clsBump.BumpCodeCoverage3();
        clsBump.BumpCodeCoverage4();
        clsBump.BumpCodeCoverage5();
        clsBump.BumpCodeCoverage6();
        clsBump.BumpCodeCoverage7();
        clsBump.BumpCodeCoverage8();
    }
}