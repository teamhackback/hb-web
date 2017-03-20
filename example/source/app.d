shared static this()
{
    import std.process : environment;
    import vibe.core.log : LogLevel, setLogLevel;
    import vibe.http.router : URLRouter;
    import vibe.http.server : HTTPServerSettings, listenHTTP;
    import vibe.db.mongo.mongo : connectMongoDB;

    setLogLevel(LogLevel.debug_);

    auto mongoHost = environment.get("APP_MONGO_URL", "mongodb://localhost");
    auto mongoDBName = environment.get("APP_MONGO_DB", "hackback");
    auto mongoDB = connectMongoDB(mongoHost).getDatabase(mongoDBName);

    // setup REST
    import hb.web.web : registerWebInterface, WebInterfaceSettings;
    auto serviceSettings = new WebInterfaceSettings();
    serviceSettings.urlPrefix = "/api";
    serviceSettings.ignoreTrailingSlash = true; // true: overloads for trailing /

    // register all services
    import offers;
    auto router = new URLRouter;
    router.registerWebInterface(new Offers(mongoDB), serviceSettings);

    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    listenHTTP(settings, router);
}
