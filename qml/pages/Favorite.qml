import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    function getDB() {
        return LocalStorage.openDatabaseSync('FavoriteDB', '1.0', 'List of favorited beer', 1000000);
    }

    Component.onCompleted: {
        var db = getDB();
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(beerId TEXT UNIQUE, beerName TEXT, beerIcon TEXT, beerLabel TEXT, beerDescription TEXT, beerAbv TEXT, beerIbu TEXT, beerSrm TEXT, beerOg TEXT, categoryName TEXT, styleName TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites2(beerId TEXT UNIQUE, breweryName TEXT, breweryId TEXT, categoryId TEXT, styleId TEXT)');
        });
    }

    function set(beerId, beerName, beerIcon, beerLabel, beerDescription, beerAbv, beerIbu, beerSrm, beerOg, categoryName, styleName, breweryName, breweryId, categoryId, styleId) {
        var db = getDB();
        var success = false;
        db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT OR REPLACE INTO favorites VALUES (?,?,?,?,?,?,?,?,?,?,?);', [beerId, beerName, beerIcon, beerLabel, beerDescription, beerAbv, beerIbu, beerSrm, beerOg, categoryName, styleName]);
            var rs2 = tx.executeSql('INSERT OR REPLACE INTO favorites2 VALUES (?,?,?,?,?);', [beerId, breweryName, breweryId, categoryId, styleId]);
            success = (rs.rowsAffected > 0) && (rs2.rowsAffected > 0);
        });
        return success;
    }

    function unset(beerId) {
        var db = getDB();
        var success = false;
        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM favorites WHERE beerId=?;', [beerId]);
            var rs2 = tx.executeSql('DELETE FROM favorites2 WHERE beerId=?;', [beerId]);
            success = (rs.rowsAffected > 0) && (rs2.rowsAffected);
        });
        return success;
    }

    function getLength() {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerId FROM favorites;', []);
            value = rs.rows.length;
        });
        return value;
    }

    function getId(index) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerId FROM favorites;', []);
            if (rs.rows.length > 0) {
                value = rs.rows.item(index).beerId;
            }
        });
        return value;
    }

    function getName(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerName FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerName;
            }
        });
        return value;
    }

    function getIcon(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerIcon FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerIcon;
            }
        });
        return value;
    }

    function getLabel(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerLabel FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerLabel;
            }
        });
        return value;
    }

    function getDescription(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerDescription FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerDescription;
            }
        });
        return value;
    }

    function getAbv(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerAbv FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerAbv;
            }
        });
        return value;
    }

    function getIbu(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerIbu FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerIbu;
            }
        });
        return value;
    }

    function getSrm(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerSrm FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerSrm;
            }
        });
        return value;
    }

    function getOg(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT beerOg FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).beerOg;
            }
        });
        return value;
    }

    function getCategory(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT categoryName FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).categoryName;
            }
        });
        return value;
    }

    function getStyle(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT styleName FROM favorites WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).styleName;
            }
        });
        return value;
    }

    function getBrewery(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT breweryName FROM favorites2 WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).breweryName;
            }
        });
        return value;
    }

    function getCatId(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT categoryId FROM favorites2 WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).categoryId;
            }
        });
        return value;
    }

    function getStyId(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT styleId FROM favorites2 WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).styleId;
            }
        });
        return value;
    }

    function getBrewId(beerId) {
        var db = getDB();
        var value = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql('SELECT breweryId FROM favorites2 WHERE beerId=?;', [beerId]);
            if (rs.rows.length > 0) {
                value = rs.rows.item(0).breweryId;
            }
        });
        return value;
    }
}
