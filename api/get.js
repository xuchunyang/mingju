const MongoClient = require("mongodb").MongoClient;

let cacheDb = null;
async function connectToDatabase() {
  if (cacheDb) return cacheDb;

  const uri = process.env.MONGODB_URI;
  const client = new MongoClient(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  await client.connect();
  const db = await client.db(new URL(uri).pathname.slice(1));
  cacheDb = db;

  return db;
}

async function search(id) {
  const db = await connectToDatabase();
  const collection = await db.collection("entries");
  return await collection.findOne({id});
}

module.exports = async (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Cache-Control", "max-age=0, s-maxage=86400");

  const { id } = req.query;
  if (!id) {
    res.status(400).json({error: "Missing id argument"});
    return;
  }

  try {
    const found = await search(Number(id));
    if (!found) {
      res.status(400).json({error: "No result"});
      return;
    }

    res.statusCode = 200;
    res.end(JSON.stringify(found, null, 2));
  } catch(e) {
    res.status(500).json({error: e.message()});
  }
};
