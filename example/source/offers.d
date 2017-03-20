import hb;
import std.algorithm.iteration : map;
import std.algorithm.searching : find;
import std.array : array;
import vibe.db.mongo.mongo;

import auth : AuthInfo, authenticate;
import std.datetime : DateTime;

@safe:

struct Offer {
    @optional @name("_id") BsonObjectID id;

    string title;
    string description;
}

@path("/offers") @requiresAuth!authenticate
class Offers
{
    MongoCollection m_offers;

    this(MongoDatabase db)
    {
        m_offers = db["offers"];
    }

    @noAuth {
        auto index()
        {
            return m_offers.find(Bson.emptyObject).map!(deserializeBson!Offer).array;
        }

        auto get(BsonObjectID _offerId)
        {
            auto offer = m_offers.findOne!Offer(["_id": _offerId]);
            enforceHTTP(!offer.isNull, notFound);
            return offer.get;
        }
    }

    @anyAuth
    auto post(Offer offer) @system
    {
        offer.id = BsonObjectID.generate();
        m_offers.insert(offer);
        status = 201;
        return offer;
    }
}
