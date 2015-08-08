package thx;

import haxe.PosInfos;
import utest.Assert;
using thx.DateTimeUtc;
import thx.Weekday;

class TestDateTimeUtc {
  var date = DateTimeUtc.create(2015, 7, 26, 21, 40, 30, 0);
  var tomorrow = DateTimeUtc.create(2015, 7, 27, 21, 40, 30, 123);

  public function new() {}

  public function testCreate() {
    Assert.equals(2015, date.year, 'expected 2015 but got ${date.year} for year');
    Assert.equals(7, date.month, 'expected 7 but got ${date.month} for month');
    Assert.equals(26, date.day, 'expected 26 but got ${date.day} for day');

    Assert.equals(21, date.hour, 'expected 21 but got ${date.hour} for hour');
    Assert.equals(40, date.minute, 'expected 40 but got ${date.minute} for minute');
    Assert.equals(30, date.second, 'expected 30 but got ${date.second} for second');

    Assert.equals(    123, tomorrow.millisecond, 'expected 123 but got ${tomorrow.millisecond} for millisecond');
    Assert.equals( 123000, tomorrow.microsecond, 'expected 123 but got ${tomorrow.microsecond} for microsecond');
    Assert.equals(1230000, tomorrow.tickInSecond, 'expected 123 but got ${tomorrow.tickInSecond} for tickInSecond');

    Assert.equals(Sunday, date.dayOfWeek);
  }

  public function testToString() {
    Assert.equals('2015-07-26T21:40:30Z', date.toString());
  }

  public function testOverflowing() {
    Assert.equals("2014-12-01T00:00:00Z", DateTimeUtc.create(2014,12,1).toString());
    // month overflow
    Assert.equals("2015-04-01T00:00:00Z", DateTimeUtc.create(2014,16,1).toString());
    Assert.equals("2013-10-01T00:00:00Z", DateTimeUtc.create(2014,-2,1).toString());

    // day overflow
    Assert.equals("2014-03-04T00:00:00Z", DateTimeUtc.create(2014,2,32).toString());
    Assert.equals("2013-12-31T00:00:00Z", DateTimeUtc.create(2014,1,0).toString());

    // hour overflow
    Assert.equals("2014-02-02T02:00:00Z", DateTimeUtc.create(2014,2,1,26).toString());
    Assert.equals("2013-12-31T23:00:00Z", DateTimeUtc.create(2014,1,1,-1).toString());

    // minute overflow
    Assert.equals("2014-02-01T01:05:00Z", DateTimeUtc.create(2014,2,1,0,65).toString());
    Assert.equals("2013-12-31T23:59:00Z", DateTimeUtc.create(2014,1,1,0,-1).toString());

    // second overflow
    Assert.equals("2014-02-01T00:01:05Z", DateTimeUtc.create(2014,2,1,0,0,65).toString());
    Assert.equals("2013-12-31T23:59:59Z", DateTimeUtc.create(2014,1,1,0,0,-1).toString());
  }

  public function testEquals() {
    Assert.isTrue(date == date);
    Assert.isTrue(date != tomorrow);
  }

  public function testCompare() {
    Assert.isFalse(date > date);
    Assert.isTrue(date >= date);
    Assert.isFalse(date < date);
    Assert.isTrue(date <= date);

    Assert.isFalse(date > tomorrow);
    Assert.isFalse(date >= tomorrow);
    Assert.isTrue(date < tomorrow);
    Assert.isTrue(date <= tomorrow);

    Assert.isTrue(tomorrow > date);
    Assert.isTrue(tomorrow >= date);
    Assert.isFalse(tomorrow < date);
    Assert.isFalse(tomorrow <= date);
  }

  public function testFromToDate() {
    var d : Date = date;
    Assert.isTrue(date == d, 'expected $date but got ${(d : DateTimeUtc)}');
  }

  public function testFromToTime() {
    var d : Float = date,
        date2 : DateTimeUtc = d;
    Assert.isTrue(date == date2, 'expected $date but got $date2');
  }

  public function testFromToString() {
    var d : String = date;
    Assert.isTrue(date == d);

    Assert.equals("-1-07-27T00:00:00Z",    ("0-06-07" : DateTimeUtc).toString());
    Assert.equals("-1-06-07T00:00:00Z",    ("-1-06-07" : DateTimeUtc).toString());
    Assert.equals("1-06-07T00:00:00Z",     ("1-06-07" : DateTimeUtc).toString());
    Assert.equals("-2014-01-01T00:00:00Z", ("-2014-01-01" : DateTimeUtc).toString());
  }

  public function testAdd() {
    var d = date
              .addYears(2)
              .addMonths(9)
              .addDays(10)
              .addHours(7)
              .addMinutes(10)
              .addSeconds(7)
              .addMilliseconds(7),
        e = "2018-05-07 04:50:37.007";
    Assert.isTrue(d == "2018-05-07 04:50:37.007", 'expected $e but got $d');
  }

  public function testNow() {
    var ref = DateHelper.nowUtc(),
        date = DateTimeUtc.now();
    Assert.isTrue(date.nearEquals(ref, Time.fromMinutes(1)), 'expected $ref but got $date');
  }
}