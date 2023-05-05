CREATE TABLE "card_holder" (
    "ch_id" int   NOT NULL,
    "ch_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_card_holder" PRIMARY KEY (
        "ch_id"
     )
);

CREATE TABLE "credit_card" (
    "card_no" varchar(20)   NOT NULL,
    "ch_id" int   NOT NULL,
    CONSTRAINT "pk_credit_card" PRIMARY KEY (
        "card_no"
     )
);

CREATE TABLE "merchant" (
    "m_id" int   NOT NULL,
    "m_name" varchar(50) NOT NULL,
    "mc_id" int   NOT NULL,
    CONSTRAINT "pk_merchant" PRIMARY KEY (
        "m_id"
     )
);

CREATE TABLE "merchant_category" (
    "mc_id" int   NOT NULL,
    "mc_name" varchar(50) NOT NULL,
    CONSTRAINT "pk_merchant_category" PRIMARY KEY (
        "mc_id"
     )
);

CREATE TABLE "transaction" (
    "tx_id" int   NOT NULL,
    "date" timestamp   NOT NULL,
    "tx_amount" float   NOT NULL,
    "card_no" varchar(20)   NOT NULL,
    "m_id" int   NOT NULL,
    CONSTRAINT "pk_transaction" PRIMARY KEY (
        "tx_id"
     )
);

ALTER TABLE "credit_card" ADD CONSTRAINT "fk_credit_card_ch_id" FOREIGN KEY("ch_id")
REFERENCES "card_holder" ("ch_id");

ALTER TABLE "merchant" ADD CONSTRAINT "fk_merchant_mc_id" FOREIGN KEY("mc_id")
REFERENCES "merchant_category" ("mc_id");

ALTER TABLE "transaction" ADD CONSTRAINT "fk_transaction_card_no" FOREIGN KEY("card_no")
REFERENCES "credit_card" ("card_no");

ALTER TABLE "transaction" ADD CONSTRAINT "fk_transaction_m_id" FOREIGN KEY("m_id")
REFERENCES "merchant" ("m_id");

CREATE INDEX "idx_card_holder_ch_name"
ON "card_holder" ("ch_name");

CREATE INDEX "idx_credit_card_ch_id"
ON "credit_card" ("ch_id");

CREATE INDEX "idx_merchant_m_name"
ON "merchant" ("m_name");

CREATE INDEX "idx_merchant_category_mc_name"
ON "merchant_category" ("mc_name");

CREATE INDEX "idx_transaction_date"
ON "transaction" ("date");

CREATE INDEX "idx_transaction_card_no"
ON "transaction" ("card_no");
