#http://cran.r-project.org/web/packages/rmongodb/vignettes/rmongodb_introduction.html

library(rmongodb)


# Connecting R to MongoDB -------------------------------------------------


m=mongo.create()
mongo.is.connected(m)


# Getting databases and collections ---------------------------------------


#get all databases of your MongoDB connection
mongo.get.databases(m)
#get one of them
db=mongo.get.databases(m)[1]

#get all collections in a specific databases fo your MongoDB 
mongo.get.database.collections(m,db)
coll=mongo.get.database.collections(m,db)


# Getting the size of collections, a sample document and values fo --------


#check how many documents are in the collection 
mongo.count(m,coll)

#Get one document from your collection
mongo.find.one(m,coll)

#the command mongo.distinct is going to provide a list of all values for a specific key
mongo.distinct(m,coll,'city')


# Finding some first data -------------------------------------------------



#Be aware that the output of "mongo.find.one" is a BSON object,
#which can not be used directly for further analysis in R.
# And, using "mongo.bson.to.list", and R list object can be created from BSON object.
temp<- mongo.find.one(m,coll,'{"city":"SHEHONG"}')
temp
class(temp)
mongo.bson.to.list(temp)


# Creating BSON objects ---------------------------------------------------

query <- mongo.bson.from.list(list('city'='SHEHONG'))
query
#this can be used in the query
mongo.find.one(m,coll,query)
mongo.find.all(m,coll,query)

query<- mongo.bson.from.list(list('city'='SHEHONG','dept'='mathematics'))
query
#internally "mongo.bson.from.list" calls "mongo.bson.buffer.create", "mongo.bson.buffer.append", 'mongo.bson.from.buffer' functions.
# But in most cases you really don't need to know anything about these internals

# Alternatively same BSON object can be created using one line of code and JSON:
query<- mongo.bson.from.JSON('{"city":"SHEHONG","dept":"mathematics"}')
query

# mongo.bson.from.list automatically converts R primitive data types(integer, numeric, logical, character) into MongoDB data types. 
# You have to make some extra job for Date types. 
# To build bson with ISODate data you shoudl pass it as POSIXct object:
date_string<- "2014-10-11 12:01:06"
query<-mongo.bson.from.list(list(date=as.POSIXct(date_string,tz='MSK')))  # pay attention to timezone argument
# note, that internall MongoDB strores dates in unixtime format:
query


# Finding more data with a more complext query ----------------------------

mongo.find.all(m,coll,query=list('city'='SHEHONG'))
mongo.find.all(m,coll,query=list('city'='SHEHONG','dept'='mathematics'))


# Inserting some data into MongoDB ----------------------------------------

a<-mongo.bson.from.JSON('{"name":"test"}')
b_1<-mongo.bson.from.JSON('{"name":"test_1"}')
b_2<-mongo.bson.from.JSON('{"name":"test_2"}')
icoll<-paste(db,'test',sep='.')
mongo.insert(m,icoll,a)
mongo.insert.batch(m,icoll,list(b_1,b_2))


# Updating documents -----------

mongo.find.all(m,icoll)
mongo.update(m,icoll,list('name'='test_2'),list('name'='changed'))
mongo.find.all(m,icoll)


# Creating indices for efficient queries ----------------------------------

# creating an index for the field 'name'
mongo.index.create(m,icoll,list('name'=1))
#how to check in mongoshell?


# Dropping/removing. Collections and databases and closing the con --------

mongo.get.database.collections(m,db)
mongo.drop(m,icoll)
mongo.get.database.collections(m,db)

#close connection
mongo.destroy(m)
#mongo.disconnect(m)
