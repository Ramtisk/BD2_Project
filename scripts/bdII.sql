drop index ADDRESS_PK;

drop table ADDRESS;

drop index TYPE_DEVICE_FK;

drop index INVENTORY_DEVICE_FK;

drop index PLAN_DEVICE_FK;

drop index DEVICE_PK;

drop table DEVICE;

drop index DEVICES_TYPE_PK;

drop table DEVICES_TYPE;

drop index DISCOUNT_PK;

drop table DISCOUNT;

drop index ADDRESS_INVENTORY_FK;

drop index INVENTORY_PK;

drop table INVENTORY;

drop index USER_PAYMENT_FK;

drop index SUBSCRIPTION_PAYMENT_FK;

drop index PAYMENT_PK;

drop table PAYMENT;

drop index PLAN_PK;

drop table PLAN;

drop index PLAN_SUBSCRIPTION2_FK;

drop index PLAN_SUBSCRIPTION_FK;

drop index PLAN_SUBSCRIPTION_PK;

drop table PLAN_SUBSCRIPTION;

drop index SUBCRIPTION_VISIT2_FK;

drop index SUBCRIPTION_VISIT_FK;

drop index SUBCRIPTION_VISIT_PK;

drop table SUBCRIPTION_VISIT;

drop index SUBSCRIPTION_DISCOUNT_FK;

drop index USER_SUBSCRIPTION_FK;

drop index SUBSCRIPTION_PK;

drop table SUBSCRIPTION;

drop index DEVICE_VISIT_FK;

drop index TECNICAL_VISIT_PK;

drop table TECNICAL_VISIT;

drop index ADDRESS_USER_FK;

drop index USER_PK;

drop index USER_VISIT2_FK;

drop index USER_VISIT_FK;

drop index USER_VISIT_PK;

drop table USER_VISIT;

ALTER TABLE auth_user
ADD COLUMN ADDRESS_ID integer;


/*==============================================================*/
/* Table: ADDRESS                                               */
/*==============================================================*/
create table ADDRESS (
   ADDRESS_ID           integer              not null,
   STREET               text,
   CITY                 text,
   POSTAL_CODE          text,
   COUNTRY              text,
   constraint PK_ADDRESS primary key (ADDRESS_ID)
);

/*==============================================================*/
/* Index: ADDRESS_PK                                            */
/*==============================================================*/
create unique index ADDRESS_PK on ADDRESS (
ADDRESS_ID
);

/*==============================================================*/
/* Table: DEVICE                                                */
/*==============================================================*/
create table DEVICE (
   DEVICE_ID            integer              not null,
   DEVICE_TYPE_ID       integer              not null,
   INVENTORY_ID         integer              not null,
   PLAN_ID              integer              not null,
   INSTALLATION_DATE    date,
   SERIAL_NUMBER        text,
   constraint PK_DEVICE primary key (DEVICE_ID)
);

/*==============================================================*/
/* Index: DEVICE_PK                                             */
/*==============================================================*/
create unique index DEVICE_PK on DEVICE (
DEVICE_ID
);

/*==============================================================*/
/* Index: PLAN_DEVICE_FK                                        */
/*==============================================================*/
create  index PLAN_DEVICE_FK on DEVICE (
PLAN_ID
);

/*==============================================================*/
/* Index: INVENTORY_DEVICE_FK                                   */
/*==============================================================*/
create  index INVENTORY_DEVICE_FK on DEVICE (
INVENTORY_ID
);

/*==============================================================*/
/* Index: TYPE_DEVICE_FK                                        */
/*==============================================================*/
create  index TYPE_DEVICE_FK on DEVICE (
DEVICE_TYPE_ID
);

/*==============================================================*/
/* Table: DEVICES_TYPE                                          */
/*==============================================================*/
create table DEVICES_TYPE (
   DEVICE_TYPE_ID       integer              not null,
   NAME                 text,
   DESCRIPTION          text,
   IMAGE                text,
   constraint PK_DEVICES_TYPE primary key (DEVICE_TYPE_ID)
);

/*==============================================================*/
/* Index: DEVICES_TYPE_PK                                       */
/*==============================================================*/
create unique index DEVICES_TYPE_PK on DEVICES_TYPE (
DEVICE_TYPE_ID
);

/*==============================================================*/
/* Table: DISCOUNT                                              */
/*==============================================================*/
create table DISCOUNT (
   DISCOUNT_ID          integer              not null,
   PASSWORD             char(256),
   PERCENT              integer,
   START_DATE           date,
   END_DATE             date,
   ACTIVE               boolean,
   constraint PK_DISCOUNT primary key (DISCOUNT_ID)
);

/*==============================================================*/
/* Index: DISCOUNT_PK                                           */
/*==============================================================*/
create unique index DISCOUNT_PK on DISCOUNT (
DISCOUNT_ID
);


/*==============================================================*/
/* Table: INVENTORY                                             */
/*==============================================================*/
create table INVENTORY (
   INVENTORY_ID         integer              not null,
   ADDRESS_ID           integer              not null,
   QUANTITY             integer,
   constraint PK_INVENTORY primary key (INVENTORY_ID)
);

/*==============================================================*/
/* Index: INVENTORY_PK                                          */
/*==============================================================*/
create unique index INVENTORY_PK on INVENTORY (
INVENTORY_ID
);

/*==============================================================*/
/* Index: ADDRESS_INVENTORY_FK                                  */
/*==============================================================*/
create  index ADDRESS_INVENTORY_FK on INVENTORY (
ADDRESS_ID
);

/*==============================================================*/
/* Table: PAYMENT                                               */
/*==============================================================*/
create table PAYMENT (
   PAYMENT_ID           integer              not null,
   SUBSCRIPTION_ID      integer              not null,
   USER_ID              integer              not null,
   AMOUNT               real,
   DATE                 date,
   ENTITY               text,
   REFENCE              text,
   API                  text,
   CELL_NUMBER          integer,
   constraint PK_PAYMENT primary key (PAYMENT_ID)
);

/*==============================================================*/
/* Index: PAYMENT_PK                                            */
/*==============================================================*/
create unique index PAYMENT_PK on PAYMENT (
PAYMENT_ID
);

/*==============================================================*/
/* Index: SUBSCRIPTION_PAYMENT_FK                               */
/*==============================================================*/
create  index SUBSCRIPTION_PAYMENT_FK on PAYMENT (
SUBSCRIPTION_ID
);

/*==============================================================*/
/* Index: USER_PAYMENT_FK                                       */
/*==============================================================*/
create  index USER_PAYMENT_FK on PAYMENT (
USER_ID
);

/*==============================================================*/
/* Table: PLAN                                                  */
/*==============================================================*/
create table PLAN (
   PLAN_ID              integer              not null,
   PASSWORD             char(256),
   DESCRIPTION          text,
   PRICE                real,
   SERVICE_TYPE         integer,
   constraint PK_PLAN primary key (PLAN_ID)
);

/*==============================================================*/
/* Index: PLAN_PK                                               */
/*==============================================================*/
create unique index PLAN_PK on PLAN (
PLAN_ID
);

/*==============================================================*/
/* Table: PLAN_SUBSCRIPTION                                     */
/*==============================================================*/
create table PLAN_SUBSCRIPTION (
   PLAN_ID              integer              not null,
   SUBSCRIPTION_ID      integer              not null,
   constraint PK_PLAN_SUBSCRIPTION primary key (PLAN_ID, SUBSCRIPTION_ID)
);

/*==============================================================*/
/* Index: PLAN_SUBSCRIPTION_PK                                  */
/*==============================================================*/
create unique index PLAN_SUBSCRIPTION_PK on PLAN_SUBSCRIPTION (
PLAN_ID,
SUBSCRIPTION_ID
);

/*==============================================================*/
/* Index: PLAN_SUBSCRIPTION_FK                                  */
/*==============================================================*/
create  index PLAN_SUBSCRIPTION_FK on PLAN_SUBSCRIPTION (
PLAN_ID
);

/*==============================================================*/
/* Index: PLAN_SUBSCRIPTION2_FK                                 */
/*==============================================================*/
create  index PLAN_SUBSCRIPTION2_FK on PLAN_SUBSCRIPTION (
SUBSCRIPTION_ID
);

/*==============================================================*/
/* Table: SUBCRIPTION_VISIT                                     */
/*==============================================================*/
create table SUBCRIPTION_VISIT (
   SUBSCRIPTION_ID      integer              not null,
   TECNICAL_VISIT_ID    integer              not null,
   constraint PK_SUBCRIPTION_VISIT primary key (SUBSCRIPTION_ID, TECNICAL_VISIT_ID)
);

/*==============================================================*/
/* Index: SUBCRIPTION_VISIT_PK                                  */
/*==============================================================*/
create unique index SUBCRIPTION_VISIT_PK on SUBCRIPTION_VISIT (
SUBSCRIPTION_ID,
TECNICAL_VISIT_ID
);

/*==============================================================*/
/* Index: SUBCRIPTION_VISIT_FK                                  */
/*==============================================================*/
create  index SUBCRIPTION_VISIT_FK on SUBCRIPTION_VISIT (
SUBSCRIPTION_ID
);

/*==============================================================*/
/* Index: SUBCRIPTION_VISIT2_FK                                 */
/*==============================================================*/
create  index SUBCRIPTION_VISIT2_FK on SUBCRIPTION_VISIT (
TECNICAL_VISIT_ID
);

/*==============================================================*/
/* Table: SUBSCRIPTION                                          */
/*==============================================================*/
create table SUBSCRIPTION (
   SUBSCRIPTION_ID      integer              not null,
   USER_ID              integer              not null,
   DISCOUNT_ID          integer,
   START_DATE           date,
   END_DATE             date,
   constraint PK_SUBSCRIPTION primary key (SUBSCRIPTION_ID)
);

/*==============================================================*/
/* Index: SUBSCRIPTION_PK                                       */
/*==============================================================*/
create unique index SUBSCRIPTION_PK on SUBSCRIPTION (
SUBSCRIPTION_ID
);

/*==============================================================*/
/* Index: USER_SUBSCRIPTION_FK                                  */
/*==============================================================*/
create  index USER_SUBSCRIPTION_FK on SUBSCRIPTION (
USER_ID
);

/*==============================================================*/
/* Index: SUBSCRIPTION_DISCOUNT_FK                              */
/*==============================================================*/
create  index SUBSCRIPTION_DISCOUNT_FK on SUBSCRIPTION (
DISCOUNT_ID
);

/*==============================================================*/
/* Table: TECNICAL_VISIT                                        */
/*==============================================================*/
create table TECNICAL_VISIT (
   TECNICAL_VISIT_ID    integer              not null,
   DEVICE_ID            integer              not null,
   NOTE                 text,
   DATE                 date,
   constraint PK_TECNICAL_VISIT primary key (TECNICAL_VISIT_ID)
);

/*==============================================================*/
/* Index: TECNICAL_VISIT_PK                                     */
/*==============================================================*/
create unique index TECNICAL_VISIT_PK on TECNICAL_VISIT (
TECNICAL_VISIT_ID
);

/*==============================================================*/
/* Index: DEVICE_VISIT_FK                                       */
/*==============================================================*/
create  index DEVICE_VISIT_FK on TECNICAL_VISIT (
DEVICE_ID
);



/*==============================================================*/
/* Index: ADDRESS_USER_FK                                       */
/*==============================================================*/
create  index ADDRESS_USER_FK on "auth_user" (
ADDRESS_ID
);

/*==============================================================*/
/* Table: USER_VISIT                                            */
/*==============================================================*/
create table USER_VISIT (
   USER_ID              integer              not null,
   TECNICAL_VISIT_ID    integer              not null,
   constraint PK_USER_VISIT primary key (USER_ID, TECNICAL_VISIT_ID)
);

/*==============================================================*/
/* Index: USER_VISIT_PK                                         */
/*==============================================================*/
create unique index USER_VISIT_PK on USER_VISIT (
USER_ID,
TECNICAL_VISIT_ID
);

/*==============================================================*/
/* Index: USER_VISIT_FK                                         */
/*==============================================================*/
create  index USER_VISIT_FK on USER_VISIT (
USER_ID
);

/*==============================================================*/
/* Index: USER_VISIT2_FK                                        */
/*==============================================================*/
create  index USER_VISIT2_FK on USER_VISIT (
TECNICAL_VISIT_ID
);

alter table DEVICE
   add constraint FK_DEVICE_INVENTORY_INVENTOR foreign key (INVENTORY_ID)
      references INVENTORY (INVENTORY_ID)
      on delete restrict on update restrict;

alter table DEVICE
   add constraint FK_DEVICE_PLAN_DEVI_PLAN foreign key (PLAN_ID)
      references PLAN (PLAN_ID)
      on delete restrict on update restrict;

alter table DEVICE
   add constraint FK_DEVICE_TYPE_DEVI_DEVICES_ foreign key (DEVICE_TYPE_ID)
      references DEVICES_TYPE (DEVICE_TYPE_ID)
      on delete restrict on update restrict;


alter table INVENTORY
   add constraint FK_INVENTOR_ADDRESS_I_ADDRESS foreign key (ADDRESS_ID)
      references ADDRESS (ADDRESS_ID)
      on delete restrict on update restrict;

alter table PAYMENT
   add constraint FK_PAYMENT_SUBSCRIPT_SUBSCRIP foreign key (SUBSCRIPTION_ID)
      references SUBSCRIPTION (SUBSCRIPTION_ID)
      on delete restrict on update restrict;

alter table PAYMENT
   add constraint FK_PAYMENT_USER_PAYM_USER foreign key (USER_ID)
      references "auth_user" (ID)
      on delete restrict on update restrict;

alter table PLAN_SUBSCRIPTION
   add constraint FK_PLAN_SUB_PLAN_SUBS_PLAN foreign key (PLAN_ID)
      references PLAN (PLAN_ID)
      on delete restrict on update restrict;

alter table PLAN_SUBSCRIPTION
   add constraint FK_PLAN_SUB_PLAN_SUBS_SUBSCRIP foreign key (SUBSCRIPTION_ID)
      references SUBSCRIPTION (SUBSCRIPTION_ID)
      on delete restrict on update restrict;

alter table SUBCRIPTION_VISIT
   add constraint FK_SUBCRIPT_SUBCRIPTI_SUBSCRIP foreign key (SUBSCRIPTION_ID)
      references SUBSCRIPTION (SUBSCRIPTION_ID)
      on delete restrict on update restrict;

alter table SUBCRIPTION_VISIT
   add constraint FK_SUBCRIPT_SUBCRIPTI_TECNICAL foreign key (TECNICAL_VISIT_ID)
      references TECNICAL_VISIT (TECNICAL_VISIT_ID)
      on delete restrict on update restrict;

alter table SUBSCRIPTION
   add constraint FK_SUBSCRIP_SUBSCRIPT_DISCOUNT foreign key (DISCOUNT_ID)
      references DISCOUNT (DISCOUNT_ID)
      on delete restrict on update restrict;

alter table SUBSCRIPTION
   add constraint FK_SUBSCRIP_USER_SUBS_USER foreign key (USER_ID)
      references "auth_user" (ID)
      on delete restrict on update restrict;

alter table TECNICAL_VISIT
   add constraint FK_TECNICAL_DEVICE_VI_DEVICE foreign key (DEVICE_ID)
      references DEVICE (DEVICE_ID)
      on delete restrict on update restrict;

alter table USER_VISIT
   add constraint FK_USER_VIS_USER_VISI_USER foreign key (USER_ID)
      references "auth_user" (ID)
      on delete restrict on update restrict;

alter table USER_VISIT
   add constraint FK_USER_VIS_USER_VISI_TECNICAL foreign key (TECNICAL_VISIT_ID)
      references TECNICAL_VISIT (TECNICAL_VISIT_ID)
      on delete restrict on update restrict;

