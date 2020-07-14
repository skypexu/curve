#
#  Copyright (c) 2020 NetEase Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

create database if not exists curve_mds;
use curve_mds;


create table if not exists `curve_clusterInfo` (
    `clusterId`        varchar(128)    NOT NULL PRIMARY KEY COMMENT 'clusterId'
)COMMENT='clusterInfo';


create table if not exists `curve_chunkserver` (
    `chunkServerID`     int            NOT NULL PRIMARY KEY COMMENT 'chunk server id',
    `token`             varchar(16)    NOT NULL COMMENT 'token to identity chunk server',
    `diskType`          varchar(8)     NOT NULL COMMENT 'disk type',
    `internalHostIP`    varchar(16)    NOT NULL COMMENT 'internal ip',
    `port`              int            NOT NULL COMMENT 'port',
    `rwstatus`          tinyint        NOT NULL COMMENT 'chunk server status: rw/ro/wo/pending/retired',
    `serverID`          int            NOT NULL COMMENT 'server where chunk server in',
    `onlineState`       tinyint        NOT NULL COMMENT 'chunk server state: online/offline',
    `diskState`         tinyint        NOT NULL COMMENT 'disk state: DiskError, DiskNormal',
    `mountPoint`        varchar(32)    NOT NULL COMMENT 'disk mount point, e.g /mnt/ssd1',
    `capacity`          bigint         NOT NULL COMMENT 'total size of disk',
    `used`              bigint         NOT NULL COMMENT 'used space'
)COMMENT='chunk server';

create table if not exists `curve_server` (
    `serverID`          int           NOT NULL PRIMARY KEY COMMENT 'server id',
    `hostName`          varchar(32)   NOT NULL COMMENT 'host name',
    `internalHostIP`    varchar(16)   NOT NULL COMMENT 'internal host ip',
    `internalPort`      int           NOT NULL COMMENT 'internal port',
    `externalHostIP`    varchar(16)   NOT NULL COMMENT 'external host ip',
    `externalPort`      int           NOT NULL COMMENT 'external port',
    `zoneID`            int           NOT NULL COMMENT 'zone id it belongs to',
    `poolID`            int           NOT NULL COMMENT 'pool id it belongs to',
    `desc`              varchar(128)  NOT NULL COMMENT 'description of server',
    unique key (`hostName`)
)COMMENT='server';

create table if not exists `curve_zone` (
    `zoneID`    int           NOT NULL PRIMARY KEY COMMENT 'zone id',
    `zoneName`  char(128)     NOT NULL COMMENT 'zone name',
    `poolID`    int           NOT NULL COMMENT 'physical pool id',
    `desc`      varchar(128)           COMMENT 'description'
)COMMENT='zone';

create table if not exists `curve_physicalpool` (
    `physicalPoolID`      smallint        NOT NULL PRIMARY KEY COMMENT 'physical pool id',
    `physicalPoolName`    varchar(32)        NOT NULL COMMENT 'physical pool name',
    `desc`                varchar(128)             COMMENT 'description',
    unique key (`physicalPoolName`)
)COMMENT='physical pool';

create table if not exists `curve_logicalpool` (
    `logicalPoolID`      smallint     NOT NULL PRIMARY KEY COMMENT 'logical pool id',
    `logicalPoolName`    char(32)     NOT NULL COMMENT 'logical pool name',
    `physicalPoolID`     int          NOT NULL COMMENT 'physical pool id',
    `type`               tinyint      NOT NULL COMMENT 'pool type',
    `initialScatterWidth` int         NOT NULL COMMENT 'initialScatterWidth',
    `createTime`         bigint       NOT NULL COMMENT 'create time',
    `status`             tinyint      NOT NULL COMMENT 'status',
    `redundanceAndPlacementPolicy`    json     NOT NULL COMMENT 'policy of redundance and placement',
    `userPolicy`         json         NOT NULL COMMENT 'user policy',
    `availFlag`          boolean      NOT NULL COMMENT 'available flag'
)COMMENT='logical pool';

create table if not exists `curve_copyset` (
    `copySetID`          int            NOT NULL COMMENT 'copyset id',
    `logicalPoolID`      smallint       NOT NULL COMMENT 'logical pool it belongs to',
    `epoch`              bigint         NOT NULL COMMENT 'copyset epoch',
    `chunkServerIDList`  varchar(32)    NOT NULL COMMENT 'list chunk server id the copyset has',
    primary key (`logicalPoolID`,`copySetID`)
)COMMENT='copyset';

create table if not exists `client_info` (
    `clientIp`         varchar(16)   NOT NULL COMMENT 'client ip',
    `clientPort`       int           NOT NULL COMMENT 'client port',
    UNIQUE KEY `key_ip_port` (`clientIp`, `clientPort`)
)COMMENT='client_info';
