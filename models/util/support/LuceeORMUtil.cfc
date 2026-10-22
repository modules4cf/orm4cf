/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * Modified by the modules4cf contributors, 2026
 * ---
 *
 * Lucee Based ORM Utility
 *
 * Restored from cborm 4.x (removed upstream in cborm 5.0.0) and adapted to
 * Lucee 6/7, whose Hibernate extension runs on Log4j 2.
 *
 * @author Luis Majano & Mike McKellip
 */
component
	implements="IORMUtil"
	extends   ="ORMUtilSupport"
	singleton
{

	/**
	 * Sets up Hibernate logging levels.
	 *
	 * @deprecated Do not use anymore, the engine will provide this
	 * @level      The logging level to set in hibernate: ALL, DEBUG, INFO, WARN, ERROR, FATAL, OFF, TRACE
	 */
	void function setupHibernateLogging( level = "WARN" ){
		var configurator = createObject( "java", "org.apache.logging.log4j.core.config.Configurator" );
		var log4jLevel   = createObject( "java", "org.apache.logging.log4j.Level" );
		configurator.setLevel( "org.hibernate", log4jLevel.toLevel( arguments.level ) );
	}

}
