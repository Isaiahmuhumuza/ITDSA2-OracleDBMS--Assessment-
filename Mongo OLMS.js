use OLMS;
db.createCollection("Provinces");
db.createCollection("Municipalities");
db.createCollection("Facilities");
db.createCollection("Rooms");
db.createCollection("Activities");
db.createCollection("Uses");

db.Provinces.insertMany([
  { provinceCode: "WC", provinceName: "Western Cape" },
  { provinceCode: "KZN", provinceName: "KwaZulu-Natal" }
]);

db.Municipalities.insertMany([
  {
    munCode: "CPT",
    munName: "City of Cape Town",
    avgPopulation: 4005016,
    provinceCode: "WC"
  },
  {
    munCode: "ETH",
    munName: "eThekwini Metropolitan Municipality",
    avgPopulation: 3702231,
    provinceCode: "KZN"
  }
]);

db.Facilities.insertMany([
  {
    facilityId: "Arts",
    facilityName: "Artscape Theatre Centre",
    capacity: 1500,
    address: "D.F. Malan St, Foreshore, Cape Town, 8001",
    munCode: "CPT",
    rooms: [
      { roomNo: 1, description: "Main Theatre" },
      { roomNo: 2, description: "Opera House" }
    ]
  },
  {
    facilityId: "ICC",
    facilityName: "Durban ICC",
    capacity: 10000,
    address: "45 Bram Fischer Rd, Durban Central, Durban 4001",
    munCode: "ETH",
    rooms: [
      { roomNo: 1, description: "Hall 1" },
      { roomNo: 2, description: "Hall 2" }
    ]
  }
]);

db.Activities.insertMany([
  { activityRef: "MUS01", activityName: "Music Concert" },
  { activityRef: "EXH01", activityName: "Art Exhibition" }
]);

db.Uses.insertMany([
  {
    facilityId: "Arts",
    activityRef: "MUS01",
    useDate: ISODate("2025-05-20T00:00:00.000Z")
  },
  {
    facilityId: "ICC",
    activityRef: "EXH01",
    useDate: ISODate("2025-06-15T00:00:00.000Z")
  }
]);


// Question 2.4

db.Facilities.find({ facilityId: "Arts" });

// Question 2.5

db.Municipalities.find({
  avgPopulation: { $gte: 3500000 }
});


// Question 2.6

db.Uses.aggregate([
  {
    $lookup: {
      from: "Facilities",
      localField: "facilityId",
      foreignField: "facilityId",
      as: "facilityDetails"
    }
  },
  { $unwind: "$facilityDetails" },
  {
    $project: {
      _id: 0,
      useDate: 1,
      facilityId: "$facilityDetails.facilityId",
      facilityName: "$facilityDetails.facilityName",
      capacity: "$facilityDetails.capacity",
      address: "$facilityDetails.address"
    }
  }
]);

// Question 2.7

db.Uses.aggregate([
  {
    $lookup: {
      from: "Activities",
      localField: "activityRef",
      foreignField: "activityRef",
      as: "activityDetails"
    }
  },
  { $unwind: "$activityDetails" },
  {
    $lookup: {
      from: "Facilities",
      localField: "facilityId",
      foreignField: "facilityId",
      as: "facilityDetails"
    }
  },
  { $unwind: "$facilityDetails" },
  {
    $lookup: {
      from: "Municipalities",
      localField: "facilityDetails.munCode",
      foreignField: "munCode",
      as: "municipalityDetails"
    }
  },
  { $unwind: "$municipalityDetails" },
  {
    $lookup: {
      from: "Provinces",
      localField: "municipalityDetails.provinceCode",
      foreignField: "provinceCode",
      as: "provinceDetails"
    }
  },
  { $unwind: "$provinceDetails" },
  {
    $project: {
      _id: 0,
      useDate: 1,
      activityRef: "$activityDetails.activityRef",
      activityName: "$activityDetails.activityName",
      facilityId: "$facilityDetails.facilityId",
      facilityName: "$facilityDetails.facilityName",
      capacity: "$facilityDetails.capacity",
      address: "$facilityDetails.address",
      municipality: "$municipalityDetails.muniName",
      province: "$provinceDetails.provinceName"
    }
  }
]);
