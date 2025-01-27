function test_suite = test_multScen

test_functions=localfunctions();

initTestSuite;

function test_multScenConstructWithCt
    ct.numOfCtScen = 1;
    model = matRad_multScen(ct,'nomScen');
    assertTrue(isa(model,'matRad_NominalScenario'));

    model = matRad_multScen(ct,'wcScen');
    assertTrue(isa(model,'matRad_WorstCaseScenarios'));
    
    model = matRad_multScen(ct,'rndScen');
    assertTrue(isa(model,'matRad_RandomScenarios'));
    
    model = matRad_multScen(ct,'impScen');
    assertTrue(isa(model,'matRad_ImportanceScenarios'));    

function test_multScenConstructWithEmptyCt
    ct = [];
    model = matRad_multScen(ct,'nomScen');
    assertTrue(isa(model,'matRad_NominalScenario'));

    model = matRad_multScen(ct,'wcScen');
    assertTrue(isa(model,'matRad_WorstCaseScenarios'));
    
    model = matRad_multScen(ct,'rndScen');
    assertTrue(isa(model,'matRad_RandomScenarios'));
    
    model = matRad_multScen(ct,'impScen');
    assertTrue(isa(model,'matRad_ImportanceScenarios'));