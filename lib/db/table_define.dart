class DSTableDefine {
  static const String categoryTable = 'categoryTable';
  static const String baiduTable = 'baiduTable';
  static const String zhihuTable = 'zhihuTable';
  static const String weiboTable = 'weiboTable';

  /*
    存储类             描述
     
    NULL              值是一个 NULL 值。
    
    INTEGER           值是一个带符号的整数，-2^63 到 2^63 - 1
    
    REAL              值是一个数字类型，dart中的 num
    
    TEXT              值是一个文本字符串，dart中的 String
    
    BLOB              值是一个 blob 数据，dart中的 Uint8List 或者 List<int> 

    */
  createCategoryTable() {
    return '''
      CREATE TABLE IF NOT EXISTS $categoryTable (
        "id"    INTEGER NOT NULL PRIMARY KEY,
        "category_name"    TEXT,
        "category_content"  TEXT,
        "category_image" BLOB
      );
      ''';
  }

  createBaiduTable() {
    return '''
      CREATE TABLE IF NOT EXISTS $baiduTable (
        "id"    INTEGER NOT NULL PRIMARY KEY,
        "app_url"   TEXT,
        "desc" TEXT,
        "hot_score" TEXT,
        "img"  TEXT,
        "query"  TEXT,
        "raw_url"  TEXT,
        "url"  TEXT,
        "word"  TEXT,
        "update_time"  TEXT
      );
      ''';
  }

  createZhihuTable() {
    return '''
      CREATE TABLE IF NOT EXISTS $zhihuTable (
        "id"    INTEGER NOT NULL PRIMARY KEY,
        "title"  TEXT,
        "url"  TEXT,
        'type' TEXT,
        "created" TEXT,
        "excerpt"  TEXT,
        "thumbnail" TEXT
      );
      ''';
  }

  createWeiboTable() {
    return '''
      CREATE TABLE IF NOT EXISTS $weiboTable (
        "id"    INTEGER NOT NULL PRIMARY KEY,
        "title"  TEXT,
        "scheme"  TEXT,
        'itemid' TEXT,
        'create'  TEXT
      );
      ''';
  }
}
