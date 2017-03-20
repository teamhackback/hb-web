@safe:

import vibe.http.server : HTTPServerRequest, HTTPServerResponse;

struct AuthInfo {
	string userId;
    bool premium;
    bool admin;
	bool isAdmin() { return this.admin; }
	bool isPremiumUser() { return this.premium; }
}

AuthInfo authenticate(HTTPServerRequest req, HTTPServerResponse res)
{
    import std.conv : to;
    import vibe.http.common : HTTPStatusException;
    import vibe.http.status : HTTPStatus;
    alias isLoggedIn = (scope req) => true; // implement your own method

    if (!isLoggedIn(req)) throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");
    return AuthInfo("dummyUser");
}
