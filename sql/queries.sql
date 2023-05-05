----------------------------------------------------------------
-- Query to confirm all data imports from CSV worked as expected
----------------------------------------------------------------
SELECT * FROM card_holder
SELECT * FROM credit_card
SELECT * FROM merchant
SELECT * FROM merchant_category
SELECT * FROM transaction
----------------------------------------------------------------
-- Query (with view) to find total transactions per card holder
----------------------------------------------------------------
CREATE VIEW total_transactions AS

SELECT ch.ch_id, ch.ch_name, COUNT(tx.tx_id) AS total_transactions
	FROM transaction	AS tx
	JOIN credit_card 	AS cc ON cc.card_no = tx.card_no
	JOIN card_holder	AS ch ON ch.ch_id = cc.ch_id
	GROUP BY ch.ch_id
	ORDER BY ch.ch_id
;

SELECT * FROM total_transactions;
-----------------------------------------------------------------
-- Query (with view) to find no. transactions <$2 per card holder
-----------------------------------------------------------------
CREATE VIEW total_sub2_tx AS

SELECT ch.ch_id, ch.ch_name, COUNT(tx.tx_amount) AS total_sub2_tx
	FROM transaction	AS tx
	JOIN credit_card 	AS cc ON cc.card_no = tx.card_no
	JOIN card_holder	AS ch ON ch.ch_id = cc.ch_id
	WHERE tx.tx_amount < 2.00
	GROUP BY ch.ch_id
	ORDER BY ch.ch_id
;

SELECT * FROM total_sub2_tx;
-----------------------------------------------------------------
-- Query (with view) to find no. transactions <$2 per tx amount
-----------------------------------------------------------------
CREATE VIEW total_sub2_txs AS

SELECT tx.tx_amount, COUNT(tx.tx_id) AS total_sub2_txs
	FROM transaction	AS tx
	WHERE tx.tx_amount < 2.00
	GROUP BY tx.tx_amount
	ORDER BY COUNT(tx.tx_id) desc
;

SELECT * FROM total_sub2_txs;
-----------------------------------------------------------------
-- Query (with view) to find top 100 transactions between 7-9am
-----------------------------------------------------------------
CREATE VIEW top_7to9_txs AS

SELECT tx.tx_amount, tx.date, COUNT(tx.tx_id) AS top_7to9_txs
	FROM transaction	AS tx
	WHERE tx.date::time BETWEEN time '07:00:00' AND time '09:00:00'
	GROUP BY tx.tx_amount, tx.date
	ORDER BY tx.tx_amount desc
	LIMIT 100
;

SELECT * FROM top_7to9_txs;
-----------------------------------------------------------------
-- Query (with view) to find no. transactions <$2 from 7-9
-----------------------------------------------------------------
CREATE VIEW total_sub2_7to9_txs AS

SELECT tx.tx_amount, COUNT(tx.tx_id) AS total_sub2_7to9_txs
	FROM transaction	AS tx
	WHERE tx.tx_amount < 2.00
	AND tx.date::time BETWEEN time '07:00:00' AND time '9:00:00'
	GROUP BY tx.tx_amount
	ORDER BY COUNT(tx.tx_id) desc

SELECT * FROM total_sub2_7to9_txs
-----------------------------------------------------------------
-- Query (with view) to find all transactions with long decimals
-----------------------------------------------------------------
CREATE VIEW long_dec_txs AS

SELECT tx.tx_amount, tx.date, COUNT(tx.tx_id) AS long_dec_txs 
	FROM transaction	AS tx
	WHERE tx.tx_amount != ROUND(tx.tx_amount::numeric,2)
	GROUP BY tx.tx_amount, tx.date
	ORDER BY tx.date::time
;

SELECT * FROM long_dec_txs;
-----------------------------------------------------------------
-- Query (with view) to find no. transactions <$2 from 9-5
-----------------------------------------------------------------
CREATE VIEW total_sub2_9to5_txs AS

SELECT tx.tx_amount, COUNT(tx.tx_id) AS total_sub2_9to5_txs
	FROM transaction	AS tx
	WHERE tx.tx_amount < 2.00
	AND tx.date::time BETWEEN time '09:00:00' AND time '17:00:00'
	GROUP BY tx.tx_amount
	ORDER BY COUNT(tx.tx_id) desc
;

SELECT * FROM total_sub2_9to5_txs;

-----------------------------------------------------------------
-- Query (with view) to find no. transactions <$2 top 5 merchant
-----------------------------------------------------------------
CREATE VIEW top_sub2_merchant_txs AS

SELECT tx.m_id, m.m_name, COUNT(tx.m_id) AS top_sub2_merchant_txs
	FROM transaction	AS tx
	JOIN merchant 		AS m ON m.m_id = tx.m_id
	WHERE tx.tx_amount < 2.00
	GROUP BY tx.m_id, m.m_name
	ORDER BY COUNT(tx.tx_id) desc
	LIMIT 5
;

SELECT * INTO TABLE top5mc FROM top_sub2_merchant_txs;
SELECT * FROM top5mc;
-----------------------------------------------------------------
-- Query (with view) to show transactions <$2 for merchant
-----------------------------------------------------------------
CREATE VIEW all_sub2_merchant_txs AS

SELECT tx.m_id, m.m_name, tx.tx_amount AS all_sub2_merchant_txs
	FROM transaction	AS tx
	JOIN merchant 		AS m ON m.m_id = tx.m_id
	JOIN top5mc			AS t5 ON t5.m_id = tx.m_id
	WHERE tx.tx_amount < 2.00 AND tx.m_id = t5.m_id
	GROUP BY tx.m_id, m.m_name, tx.tx_amount
	ORDER BY m.m_name
;

SELECT * FROM all_sub2_merchant_txs;

-----------------------------------------------------------------
-- Query (with view) show transactions <$2 for each top merchant
-----------------------------------------------------------------
CREATE VIEW all_sub2_merchant_txs AS

SELECT tx.m_id, m.m_name, tx.tx_amount AS all_sub2_merchant_txs
	FROM transaction	AS tx
	JOIN merchant 		AS m ON m.m_id = tx.m_id
	JOIN top5mc			AS t5 ON t5.m_id = tx.m_id
	WHERE tx.tx_amount < 2.00 AND tx.m_id = t5.m_id
	GROUP BY tx.m_id, m.m_name, tx.tx_amount
	ORDER BY m.m_name
;

SELECT * FROM all_sub2_merchant_txs;

-----------------------------------------------------------------
-- Query (with view) to find merchants with long decimal txs
-----------------------------------------------------------------
CREATE VIEW long_dec_txs AS

SELECT tx.tx_amount, tx.date, m.m_name, COUNT(tx.tx_id) AS long_dec_txs 
	FROM transaction	AS tx
	JOIN merchant 		AS m ON m.m_id = tx.m_id
	WHERE tx.tx_amount != ROUND(tx.tx_amount::numeric,2)
	GROUP BY tx.tx_amount, tx.date, m.m_name
	ORDER BY tx.date::time
;

SELECT * FROM long_dec_txs;

-----------------------------------------------------------------
-- Query (with view) show potential fraudlent tx top merchant
-----------------------------------------------------------------
CREATE VIEW merc_long_txs AS

SELECT tx.tx_amount, tx.date, m.m_name AS merc_long_txs
	FROM transaction	AS tx
	JOIN merchant 		AS m ON m.m_id = tx.m_id
	JOIN top5mc			AS t5 ON t5.m_id = tx.m_id
	WHERE tx.tx_amount != ROUND(tx.tx_amount::numeric,2)
	AND tx.m_id = t5.m_id
	GROUP BY tx.tx_amount, tx.date, m.m_name 
	ORDER BY m.m_name
;

CREATE VIEW merc_long_txs AS

SELECT tx.tx_amount, tx.date, m.m_name AS merc_long_txs
	FROM transaction	AS tx
	JOIN merchant 		AS m ON m.m_id = tx.m_id
	JOIN top5mc			AS t5 ON t5.m_id = tx.m_id
	WHERE tx.tx_amount != ROUND(tx.tx_amount::numeric,2)
	AND tx.m_id = t5.m_id
	GROUP BY tx.tx_amount, tx.date, m.m_name 
	ORDER BY m.m_name
;

SELECT * FROM merc_long_txs;





















