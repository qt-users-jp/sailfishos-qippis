/* Copyright (c) 2012-2013 QNeptunea Project.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the QNeptunea nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL QNEPTUNEA BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "twitter4qml.h"
#if QT_VERSION >= 0x050000
#include <QtQml/qqml.h>
#else
#include <QtDeclarative/qdeclarative.h>
#endif

// Timelines
#include <statusesmentionstimeline.h>
#include <statuseshometimeline.h>
#include <statusesusertimeline.h>
#include <statusesretweetsofme.h>

// Tweets
#include <statusesretweets.h>
#include <status.h>

// Search
#include <searchtweets.h>

// Streaming
#include <userstream.h>
#include <statusesfilter.h>

// Direct Messages
#include <directmessages.h>
#include <directmessagessent.h>
#include <directmessage.h>

// Friends & Followers
#include <friendshipsnoretweetsids.h>
#include <followersids.h>
#include <friendsids.h>
#include <friendshipsincoming.h>
#include <friendshipsoutgoing.h>
#include <followerslist.h>
#include <friendslist.h>
#include <friendshipsshow.h>

// Users
#include <accountsettings.h>
#include <accountverifycredentials.h>
#include <accountsettingsupdate.h>
#include <accountupdateprofile.h>
#include <blockslist.h>
#include <blocksids.h>
#include <userslookup.h>
#include <user.h>
#include <userssearch.h>

// Suggested Users
#include <userssuggestions.h>
#include <userssuggestionsslug.h>

// Favorites
#include <favoriteslist.h>

// Lists
#include <listslist.h>
#include <listsstatuses.h>
#include <listsmemberships.h>
#include <listsmembers.h>
#include <listssubscriptions.h>
#include <list.h> // TODO ?

// Saved Searches
#include <savedsearcheslist.h>

// Places & Geo
#include <georeversegeocode.h>
#include <geosearch.h>

// Trends
#include <trendsplace.h>
#include <trendsavailable.h>

// Spam Reporting

// OAuth
#include <oauth.h>

// Help
#include <helpconfiguration.h>
#include <helplanguages.h>
#include <helpprivacy.h>
#include <helptos.h>
#include <applicationratelimitstatus.h>

#include <oauthmanager.h>

// #include <related_results/showrelatedresults.h>
// #include <activitysummary.h>

Twitter4QML::Twitter4QML(QObject *parent)
    : QObject(parent)
{
    int major = 1;
    int minor = 1;

    qmlRegisterUncreatableType<Twitter4QML>("harbour.qippis.Twitter4QML", major, minor, "Twitter4QML", "access twitter4qml directly.");

    // REST API v1.1 Resources
    // https://dev.twitter.com/docs/api/1.1

    // Timelines
    qmlRegisterType<StatusesMentionsTimeline>("harbour.qippis.Twitter4QML", major, minor, "StatusesMentionsTimelineModel");
    qmlRegisterType<StatusesUserTimeline>("harbour.qippis.Twitter4QML", major, minor, "StatusesUserTimelineModel");
    qmlRegisterType<StatusesHomeTimeline>("harbour.qippis.Twitter4QML", major, minor, "StatusesHomeTimelineModel");
    qmlRegisterType<StatusesRetweetsOfMe>("harbour.qippis.Twitter4QML", major, minor, "StatusesRetweetsOfMeModel");

    // Tweets
    qmlRegisterType<StatusesRetweets>("harbour.qippis.Twitter4QML", major, minor, "StatusesRetweetsModel");
    qmlRegisterType<Status>("harbour.qippis.Twitter4QML", major, minor, "Status");

    // Search
    qmlRegisterType<SearchTweets>("harbour.qippis.Twitter4QML", major, minor, "SearchTweetsModel");

    // Streaming
    qmlRegisterType<UserStream>("harbour.qippis.Twitter4QML", major, minor, "UserStreamModel");
    qmlRegisterType<StatusesFilter>("harbour.qippis.Twitter4QML", major, minor, "StatusesFilterModel");

    // Direct Messages
    qmlRegisterType<DirectMessages>("harbour.qippis.Twitter4QML", major, minor, "DirectMessagesModel");
    qmlRegisterType<DirectMessagesSent>("harbour.qippis.Twitter4QML", major, minor, "DirectMessagesSentModel");
    qmlRegisterType<DirectMessage>("harbour.qippis.Twitter4QML", major, minor, "DirectMessage");

    // Friends & Followers
    qmlRegisterType<FriendshipsNoRetweetsIds>("harbour.qippis.Twitter4QML", major, minor, "FriendshipsNoRetweetsIdsModel");
    qmlRegisterType<FriendsIds>("harbour.qippis.Twitter4QML", major, minor, "FriendsIdsModel");
    qmlRegisterType<FollowersIds>("harbour.qippis.Twitter4QML", major, minor, "FollowersIdsModel");
    qmlRegisterType<FriendshipsIncoming>("harbour.qippis.Twitter4QML", major, minor, "FriendshipsIncomingModel");
    qmlRegisterType<FriendshipsOutgoing>("harbour.qippis.Twitter4QML", major, minor, "FriendshipsOutgoingModel");
    qmlRegisterType<FriendshipsShow>("harbour.qippis.Twitter4QML", major, minor, "FriendshipsShow");
    qmlRegisterType<FriendsList>("harbour.qippis.Twitter4QML", major, minor, "FriendsListModel");
    qmlRegisterType<FollowersList>("harbour.qippis.Twitter4QML", major, minor, "FollowersListModel");



    qmlRegisterType<UsersLookup>("harbour.qippis.Twitter4QML", major, minor, "UsersLookupModel");
    qmlRegisterType<User>("harbour.qippis.Twitter4QML", major, minor, "User");
    qmlRegisterType<UsersSuggestions>("harbour.qippis.Twitter4QML", major, minor, "UsersSuggestionsModel");
    qmlRegisterType<UsersSuggestionsSlug>("harbour.qippis.Twitter4QML", major, minor, "UsersSuggestionsSlugModel");
    qmlRegisterType<UsersSearch>("harbour.qippis.Twitter4QML", major, minor, "UsersSearchModel");

    qmlRegisterType<FavoritesList>("harbour.qippis.Twitter4QML", major, minor, "FavoritesListModel");

    qmlRegisterType<ListsList>("harbour.qippis.Twitter4QML", major, minor, "ListsListModel");
    qmlRegisterType<ListsSubscriptions>("harbour.qippis.Twitter4QML", major, minor, "ListsSubscriptionsModel");
    qmlRegisterType<ListsMemberships>("harbour.qippis.Twitter4QML", major, minor, "ListsMembershipsModel");
    qmlRegisterType<ListsStatuses>("harbour.qippis.Twitter4QML", major, minor, "ListStatusesModel");
    qmlRegisterType<ListsMembers>("harbour.qippis.Twitter4QML", major, minor, "ListMembersModel");
    qmlRegisterType<List>("harbour.qippis.Twitter4QML", major, minor, "List");

    qmlRegisterType<AccountVerifyCredentials>("harbour.qippis.Twitter4QML", major, minor, "AccountVerifyCredentials");
    qmlRegisterType<AccountUpdateProfile>("harbour.qippis.Twitter4QML", major, minor, "AccountUpdateProfile");
    qmlRegisterType<AccountSettings>("harbour.qippis.Twitter4QML", major, minor, "AccountSettings");
    qmlRegisterType<ApplicationRateLimitStatus>("harbour.qippis.Twitter4QML", major, minor, "ApplicationRateLimitStatus");

    qmlRegisterType<SavedSearchesList>("harbour.qippis.Twitter4QML", major, minor, "SavedSearchesModel");

    qmlRegisterType<GeoSearch>("harbour.qippis.Twitter4QML", major, minor, "GeoSearchModel");
    qmlRegisterType<GeoReverseGeocode>("harbour.qippis.Twitter4QML", major, minor, "GeoReverseGeocodeModel");

    qmlRegisterType<TrendsPlace>("harbour.qippis.Twitter4QML", major, minor, "TrendsPlaceModel");
    qmlRegisterType<TrendsAvailable>("harbour.qippis.Twitter4QML", major, minor, "TrendsAvailableModel");

    qmlRegisterType<OAuth>("harbour.qippis.Twitter4QML", major, minor, "OAuth");

    qmlRegisterType<HelpConfiguration>("harbour.qippis.Twitter4QML", major, minor, "HelpConfiguration");
    qmlRegisterType<HelpLanguages>("harbour.qippis.Twitter4QML", major, minor, "HelpLanguagesModel");

    qmlRegisterType<HelpPrivacy>("harbour.qippis.Twitter4QML", major, minor, "HelpPrivacy");
    qmlRegisterType<HelpTos>("harbour.qippis.Twitter4QML", major, minor, "HelpTos");

}

QNetworkAccessManager *Twitter4QML::networkAccessManager() const
{
    return OAuthManager::instance().networkAccessManager();
}

void Twitter4QML::setNetworkAccessManager(QNetworkAccessManager *networkAccessManager)
{
    OAuthManager::instance().setNetworkAccessManager(networkAccessManager);
}
