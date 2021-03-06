package thx;

import utest.Assert;
using thx.Arrays;
using thx.Iterators;
using thx.Maps;

class TestMaps {
  public function new() { }

  public function testTuples() {
    var map = [
      "key1" => 1,
      "key2" => 2
    ];

    var tuples = map.tuples();
    tuples.sort(function(a, b) return Strings.compare(a._0, b._0));

    Assert.equals(2, tuples.length);
    Assert.equals(tuples[0]._0, "key1");
    Assert.equals(tuples[0]._1, 1);
    Assert.equals(tuples[1]._0, "key2");
    Assert.equals(tuples[1]._1, 2);
  }

  public function testValues() {
    var map = [
      "key1" => 1,
      "key2" => 2,
      "key3" => 3
    ];
    var values = map.values().order(Ints.compare);
    Assert.same([1, 2, 3], values);
  }

  public function testMerge() {
    var map1 = [
      "key1" => 1,
      "key2" => 1,
      "key3" => 1,
    ];
    var map2 = [
      "key2" => 2,
      "key3" => 2,
    ];
    var map3 = [
      "key3" => 3,
    ];
    // Merge into new empty map
    var result1 = (new Map() : Map<String, Int>).merge([map1, map2, map3]);
    Assert.same(3, result1.keys().toArray().length);
    Assert.same(1, result1.get("key1"));
    Assert.same(2, result1.get("key2"));
    Assert.same(3, result1.get("key3"));

    // Merge empty sources into new map
    var result2 = (["mykey" => 5] : Map<String, Int>).merge([]);
    Assert.same(1, result2.keys().toArray().length);
    Assert.same(5, result2.get("mykey"));

    // Make sure source maps are not modified by above
    Assert.same(3, map1.keys().toArray().length);
    Assert.same(1, map1.get("key1"));
    Assert.same(1, map1.get("key2"));
    Assert.same(1, map1.get("key3"));
    Assert.same(2, map2.keys().toArray().length);
    Assert.same(2, map2.get("key2"));
    Assert.same(2, map2.get("key3"));
    Assert.same(1, map3.keys().toArray().length);
    Assert.same(3, map3.get("key3"));

    // In-place merge into map1 (map2 and map3 should not be modified)
    // result3 should be the same as map1
    var result3 = map1.merge([map2, map3]);
    Assert.same(3, result3.keys().toArray().length);
    Assert.same(1, result3.get("key1"));
    Assert.same(2, result3.get("key2"));
    Assert.same(3, result3.get("key3"));
    Assert.same(3, map1.keys().toArray().length);
    Assert.same(1, map1.get("key1"));
    Assert.same(2, map1.get("key2"));
    Assert.same(3, map1.get("key3"));
    Assert.same(2, map2.keys().toArray().length);
    Assert.same(2, map2.get("key2"));
    Assert.same(2, map2.get("key3"));
    Assert.same(1, map3.keys().toArray().length);
    Assert.same(3, map3.get("key3"));
  }
}
