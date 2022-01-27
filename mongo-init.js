db.auth('CbTspRootUser', 'CbTspRootPassword')

db.createUser(
        {
            user: "CbTspSctUser",
            pwd: "CbTspScPassword",
            roles: [
                {
                    role: "dbOwner",
                    db: "socialcardb"
                }
            ]
        }
);

db.admins.insert({"username" : "admin", "password" : "admin"})
