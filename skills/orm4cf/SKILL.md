---
name: orm4cf
description: >
  Using orm4cf, the community-maintained, cross-engine continuation of cborm 5.x (ColdBox ORM
  enhancements for Hibernate) by modules4cf, tested on Lucee 6 and 7 and Adobe ColdFusion 2023 and 2025.
  Use this skill when the user works with orm4cf or cborm in a ColdBox app, needs ORM entity services
  (BaseORMService, VirtualEntityService), Active Record (ActiveEntity), Hibernate criteria queries
  (newCriteria, CriteriaBuilder), dynamic finders (findBy..., countBy...), the entityService injection DSL,
  the UniqueValidator, or migrates an app from cborm to orm4cf, especially on Lucee.
license: Apache-2.0
metadata:
  homepage: https://github.com/modules4cf/orm4cf
  based-on: cborm 5.1.0 by Ortus Solutions
---

# orm4cf

orm4cf is a fork of [cborm](https://github.com/coldbox-modules/cborm) **5.1.0** by Ortus Solutions, Corp
(Apache License 2.0), maintained by the [modules4cf](https://github.com/modules4cf) contributors. It
restores Lucee support, which cborm 5.x dropped. The API is the cborm 5.x API, so the
[cborm documentation](https://coldbox-orm.ortusbooks.com/) applies. Not affiliated with Ortus Solutions.

For the org, naming and general install options see the
[modules4cf skill](https://raw.githubusercontent.com/modules4cf/.github/main/skills/modules4cf/SKILL.md).

## Requirements

- **Engines (tested in CI):** Lucee 6, Lucee 7, Adobe ColdFusion 2023, Adobe ColdFusion 2025.
  BoxLang is not a target (some inherited BoxLang code paths exist but are untested).
- **Lucee:** Lucee's Hibernate ORM extension (Hibernate 5.x). The readme states 5.6.15.10 or later;
  CI runs 5.6.15.20 (extension ID `FAD1E8CB-4F45-4184-86359145767C29DE`). Use Lucee's extension,
  not the older Ortus ORM extension.
- **Adobe ColdFusion:** the `orm` package (Hibernate 5.x).
- **ColdBox:** 8 (CI tests `^8.0.0`).
- **Dependencies** (installed automatically): cbvalidation `^4`, mementifier `^3`, cbstreams `^2` from ForgeBox,
  and cbpaginator 2.8.3 from its GitHub repo (`coldbox-modules/cbpaginator`, pinned to a commit).

## Install

orm4cf is released on GitHub (latest: `v5.2.1`) but is **not on ForgeBox yet**. Install a release tag
from GitHub:

```bash
box install modules4cf/orm4cf#v5.2.1
# or: box install git+https://github.com/modules4cf/orm4cf.git#v5.2.1
```

Each [GitHub release](https://github.com/modules4cf/orm4cf/releases) also has the module zip attached as
`orm4cf-<version>.zip`, at `https://github.com/modules4cf/orm4cf/releases/download/v<version>/orm4cf-<version>.zip`.

This installs into `modules/orm4cf/`. Use orm4cf's own release tags (`v5.2.0` and later). Don't pin the
inherited `v5.1.0` or `v6.0.0-beta.*` tags: they are upstream cborm code without the Lucee fixes.
Once published, `box install orm4cf` will work.

Enable ORM in `Application.cfc` as usual, and add the `/cborm` mapping (needed because the ORM starts
before ColdBox, so module mappings don't exist yet when entities or the event handler load):

```js
this.mappings[ "/cborm" ] = COLDBOX_APP_ROOT_PATH & "modules/orm4cf";
this.ormEnabled  = true;
this.ormSettings = {
    // optional: route ORM events through ColdBox interceptors
    eventHandling : true,
    eventHandler  : "cborm.models.EventHandler"
};
```

## Names: what is `orm4cf` and what stays `cborm`

| Thing | Value |
|---|---|
| ForgeBox slug / `box.json` dependency / install folder | `orm4cf` |
| ColdBox module name (folder name), e.g. `getModuleSettings( "orm4cf" )` | `orm4cf` |
| CFML mapping and component paths | `/cborm`, `cborm.models.*` |
| WireBox model namespace | `@cborm` (e.g. `BaseORMService@cborm`, `UniqueValidator@cborm`) |
| Settings key in `config/ColdBox.cfc` | `moduleSettings.cborm` |
| Injection DSL | `entityService`, `entityService:{entityName}` |

## Settings (`config/ColdBox.cfc`)

Defaults from `ModuleConfig.cfc`:

```js
moduleSettings = {
    cborm : {
        resources : {
            eventLoader  : false, // register pre/post{Entity}{Action} events for resources
            eventPrefix  : "",
            maxRows      : 25,    // pagination default
            maxRowsLimit : 500    // 0 = no limit
        },
        injection : { enabled : true, include : "", exclude : "" } // WireBox injection into entities
    }
};
```

## Key APIs

### Base service (any entity, entity name as first argument)

```js
property name="ormService" inject="entityService";

var user  = ormService.get( "User", id );        // new entity if not found (returnNew=true)
var user  = ormService.getOrFail( "User", id );  // throws EntityNotFound
var users = ormService.list( entityName = "User", sortOrder = "lastName asc", max = 10 );
var one   = ormService.findWhere( "User", { userName : "luis" } );
var all   = ormService.findAllWhere( "User", { isActive : true } );
var total = ormService.count( "User" );
ormService.save( user );
ormService.delete( user );
ormService.deleteByID( "User", id );
```

### Virtual entity service (bound to one entity)

```js
property name="userService" inject="entityService:User";
// or: new cborm.models.VirtualEntityService( entityName = "User" )

var user  = userService.new( { firstName : "Luis" } );
userService.save( user );
var users = userService.list( asStream = true ); // cbstreams Stream
```

Extend `cborm.models.VirtualEntityService` for a concrete service and call `super.init( entityName = "User" )`.

### Active Record

```js
component persistent="true" entityname="User" table="users" extends="cborm.models.ActiveEntity" {
    property name="id" fieldtype="id" generator="uuid";
    property name="lastName";
}

var user = new User();            // or entityNew( "User" )
user.populate( rc ).save();       // populate, isValid(), getValidationResults(), save(), delete()
var found = new User().getOrFail( id );
```

### Dynamic finders and counters

```js
userService.findByLastName( "majano" );          // one entity
userService.findAllByLastNameLike( "ma%" );      // array
userService.countByLastName( "majano" );
ormService.findAllByLastLoginBetween( "User", "01/01/2008", "11/01/2008" ); // base service: entity first
```

Supports `And`/`Or` and conditions such as `Like`, `Between`, `IsNull`, `IsNotNull`.
A trailing struct argument holds options (`ignoreCase`, `maxResults`, `offset`, `cacheable`, `cacheName`, `timeout`).

### Criteria queries

```js
var admins = userService
    .newCriteria()
    .isTrue( "isActive" )
    .joinTo( "role", "r" )          // joinTo = createAlias( associationName, alias [, joinType] )
    .eq( "r.role", "admin" )
    .list( max = 25, offset = 0, sortOrder = "lastName asc" );

var n    = userService.newCriteria().like( "lastName", "ma%" ).count();
var user = userService.newCriteria().eq( "userName", "luis" ).getOrFail(); // throws EntityNotFound

userService.newCriteria()
    .withProjections( property = "id,fname:firstName,lname:lastName" )
    .asStruct()
    .list();
```

`eq`, `gt`, `lt`, `in` are aliases of `isEq`, `isGt`, `isLT`, `isIn`; prefix a restriction with `not`
for negation (for example `notEq`). `asStream()` returns a cbstreams Stream.

### Validation

```js
this.constraints = { userName : { required : true, validator : "UniqueValidator@cborm" } };
```

### REST resources

Handlers can extend `cborm.models.resources.BaseHandler` for CRUD resources
([docs](https://coldbox-orm.ortusbooks.com/orm-events/automatic-rest-crud)).

## Migrating from cborm

1. Replace the dependency: remove `cborm`, run `box install modules4cf/orm4cf#v5.2.1` (or `orm4cf` once on ForgeBox).
2. Point the `/cborm` application mapping at the new folder: `modules/orm4cf` instead of `modules/cborm`.
3. Calls that use the ColdBox module **name** (`getModuleSettings( "cborm" )`, `getModuleConfig( "cborm" )`,
   another module's `this.dependencies = [ "cborm" ]`) must use `orm4cf`, because the module is
   registered under its folder name.
4. Nothing else changes: `cborm.models.*` paths, `@cborm` WireBox IDs, `moduleSettings.cborm`,
   the `entityService` DSL and all APIs stay the same.

## Common pitfalls

- **Missing `/cborm` mapping:** entities extending `cborm.models.ActiveEntity` or the ORM `eventHandler`
  fail to resolve at ORM startup. Add the mapping in `Application.cfc` (see Install).
- **Wrong mapping target:** the install folder is `modules/orm4cf`, not `modules/cborm`.
- **Eager injection in ORM event handlers:** always lazy-load dependencies there (for example
  `provider:` injection) to avoid start-up ordering problems.
- **`joinTo()` needs an alias:** `joinTo( "role", "r" )`, then reference properties as `r.property`.
- **`get()` returns a new entity when not found:** use `getOrFail()` or `get( ..., returnNew = false )`
  when "not found" must be detected.
- **Lucee:** install Lucee's Hibernate extension (not the old Ortus extension) and match the version CI uses.

## Links

- Source and issues: <https://github.com/modules4cf/orm4cf> · <https://github.com/modules4cf/orm4cf/issues>
- API docs (cborm 5.x, same API): <https://coldbox-orm.ortusbooks.com/>
- Original project: [cborm](https://github.com/coldbox-modules/cborm) by Ortus Solutions, Corp (Apache 2.0)
- Questions: [Lucee Dev Forum](https://dev.lucee.org), [CFML Slack](https://cfml.slack.com)
