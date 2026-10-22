# orm4cf

**orm4cf** is a community-maintained ORM module for CFML engines, maintained by the [modules4cf](https://github.com/modules4cf) contributors. It enhances the Hibernate-based CFML ORM with service layers, Active Record, fluent criteria queries, dynamic finders and more.

> **Status:** orm4cf starts from cborm 5.1.0. Lucee support, which cborm 5.x dropped, is planned to be restored.

## Origin and attribution

orm4cf is a fork of [cborm](https://github.com/coldbox-modules/cborm) version 5.1.0 by Ortus Solutions, Corp. The original cborm documentation is at <https://coldbox-orm.ortusbooks.com/> and still describes most of the API.

Original copyright: *Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp*

orm4cf, like cborm, is licensed under the [Apache License, Version 2.0](LICENSE). See [NOTICE](NOTICE) for attribution details.

ColdBox and cborm are trademarks of Ortus Solutions, Corp, used here for attribution only. This project is not affiliated with, sponsored by, or endorsed by Ortus Solutions, Corp.

## Features

* Service Layers with all the methods you could probably think off to help you get started in any project
* Virtual service layers so you can create virtual services for any entity in your application
* ActiveEntity our implementation of Active Record for ORM
* Fluent queries via Hibernate's criteria and detached criteria queries with some Dynamic CFML goodness
* Dynamic finders and counters
* Entity population from json, structs, xml, and queryies including building up their relationships
* Entity validation
* Includes the [Mementifier project](https://www.forgebox.io/view/mementifier) to produce memento states from any entity, great for producing JSON
* Ability for finders and queries to be returned as Java streams using our [cbStreams](https://www.forgebox.io/view/cbstreams) project.
* Automatic REST CRUD, stop wasting time building resources and just leverage our base resource: https://coldbox-orm.ortusbooks.com/orm-events/automatic-rest-crud

```js
# A quick preview of some functionality

var book = new Book().findByTitle( "My Awesome Book" );
var book = new Book().getOrFail( 2 );

property name="userService" inject="entityService:User";

return userService.list();
return userService.list( asStream=true );

userService
	.newCriteria()
	.eq( "name", "luis" )
	.isTrue( "isActive" )
	.getOrFail();

userService
	.newCriteria()
	.isTrue( "isActive" )
	.joinTo( "role" )
		.eq( "name", "admin" )
	.asStream()
	.list();

userService
	.newCriteria()
	.withProjections( property="id,fname:firstName,lname:lastName,age" )
	.isTrue( "isActive" )
	.joinTo( "role" )
		.eq( "name", "admin" )
	.asStruct()
	.list();
```

### In other words, it makes using an ORM not SUCK! :rocket:

## LICENSE

Apache License, Version 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

## IMPORTANT LINKS

* Source: https://github.com/modules4cf/orm4cf
* [Changelog](changelog.md)
* Issues: https://github.com/modules4cf/orm4cf/issues
* Upstream documentation (cborm): https://coldbox-orm.ortusbooks.com/

## SYSTEM REQUIREMENTS

* Boxlang 1+ (Preferred)
  * Hibernate 5.6.15 via the `bx-orm` module
* Lucee 6, 7 via Lucee's Hibernate ORM extension (5.6.15.10 or later)
  * Hibernate 5.x
* ColdFusion 2023, 2025 via their orm module
  * Hibernate 5.x

# INSTRUCTIONS

Use the CommandBox CLI to install:

```bash
# orm4cf is not published to ForgeBox yet. Until then, install from git:
box install modules4cf/orm4cf
```

Unfortunately, due to the way that ORM is loaded by ColdFusion, if you are using the ORM EventHandler or `ActiveEntity` or any ColdBox Proxies that require ORM, you must create an Application Mapping in the `Application.cfc` like this:

```js
this.mappings[ "/cborm" ] = COLDBOX_APP_ROOT_PATH & "modules/cborm";
```

This is due to the fact that the ORM event listener starts before ColdBox, so no dynamic mappings exist yet.  **Important**: Make sure you ALWAYS lazy load dependencies in your event handlers to avoid chicken and the egg issues.

## WireBox DSL

The module also registers a new WireBox DSL called `entityservice` which can produce virtual or base ORM entity services:

* `entityservice` -  Inject a global ORM service so you can work with ANY entity
* `entityservice:{entityName}` - Inject a Virtual entity service according to `entityName`

## Settings

Here are the module settings you can place in your `config/Coldbox.cfc` under the `moduleSettings.cborm` structure:

```js
moduleSettings = {
	cborm = {
		// Resource Settings
		resources : {
			// Enable the ORM Resource Event Loader
			eventLoader  : false,
			// Prefix to use on all the registered pre/post{Entity}{Action} events
			eventPrefix : "",
			// Pagination max rows
			maxRows      : 25,
			// Pagination max row limit: 0 = no limit
			maxRowsLimit : 500
		},
		// WireBox Injection Bridge
		injection : {
			enabled : true,
			include : "",
			exclude : ""
		}
	}
};
```

## Validation

We have also migrated the `UniqueValidator` from the **validation** module into our
ORM module.  It is mapped into wirebox as `UniqueValidator@cborm` so you can use in your constraints like so:

```js
this.constraints = {
    "name"  : {
              "required":true,
              "validator":"UniqueValidator@cborm"
            }
};
```

> **Note:** the module is still installed and mapped as `cborm` (folder, mappings, `@cborm` WireBox IDs). That stays the same for now to keep it compatible.

## Contributing

All contributions welcome! Feel free to fix a typo, add a feature :rocket:, or add a testbox spec for a newly discovered issue :bug:

If you want to get hacking on orm4cf, here's how to start:

1. Make sure you have CommandBox installed: https://www.ortussolutions.com/products/commandbox#download
2. Star, Fork, and Clone down this repo: https://github.com/modules4cf/orm4cf
3. Start a MySQL 5+ service or you can use our `docker-compose.yml` file. Just make sure you have Docker installed. `run-script startdbs` or run it manually below.

```bash
docker run \
    -e MYSQL_RANDOM_ROOT_PASSWORD=yes \
    -e MYSQL_USER=other \
    -e MYSQL_PASSWORD=ortussolutions \
    -e MYSQL_DATABASE=coolblog \
    -v "$PWD/test-harness/tests/resources":/docker-entrypoint-initdb.d \
    -p 3306:3306 \
    --detach \
    --name cborm_mysql \
    mysql
```

3. Copy `.env.template` to `.env` and enter the database credentials used in step 2 above ☝
4. Install the project dependencies with CommandBox `box run-script install:dependencies`
5. Start a test server - `box start server-boxlang-cfml@1.json`
6. Hack away! :laptop:
