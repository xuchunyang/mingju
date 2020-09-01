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

async function random() {
  const db = await connectToDatabase();
  const collection = await db.collection("entries");
  const cursor = await collection.aggregate(
    [ { $sample: { size: 1 } } ]
  );
  const arr = await cursor.toArray();
  return arr[0];
}

module.exports = async (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Access-Control-Allow-Origin", "*");
  try {
    res.statusCode = 200;
    res.end(JSON.stringify(await random(), null, 2));
  } catch(e) {
    res.status(500).json({error: e.message()});
  }
};
