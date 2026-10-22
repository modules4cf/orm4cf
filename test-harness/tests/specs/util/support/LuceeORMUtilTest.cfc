component extends="ORMUtilSupportTest" skip="notLucee" {

	function setup(){
		super.setup();
		variables.ormUtil = createMock( "cborm.models.util.support.LuceeORMUtil" );
		// CF ENGINE MUST HAVE coolblog as a DSN
		variables.dsn     = "coolblog";
	}

}
