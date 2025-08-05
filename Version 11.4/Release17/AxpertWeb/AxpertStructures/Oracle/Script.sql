<<
CREATE OR REPLACE VIEW VW_CARDS_HOMEPAGES AS 
  SELECT
	a.cardtype,
	a.cardname,
	a.cardicon,
	a.charttype, 
	a.pluginname,
	CASE
		WHEN a.pluginname IS NULL THEN a.html_editor_card
		ELSE h.htmltext
	END AS htmltext,
	a.card_datasource,
	s.sqltext sqltext,
	a.width,
	a.height,
	a.autorefresh,
	uroles.role AS uroles,
	a.axp_cardsid,
	h.context,
	a.orderno,
	a.chartjson,ROW_NUMBER() over(PARTITION BY uroles.ROLE,CARDTYPE,cardname ORDER BY uroles.ROLE,CARDTYPE,cardname) rno
FROM
	axp_cards a
LEFT JOIN
ax_htmlplugins h ON
	a.pluginname = h."name"
LEFT JOIN
axdirectsql s ON
	a.card_datasource = s.sqlname
LEFT JOIN
(SELECT a.AXP_CARDSID, b.column_value role	FROM axp_cards a , table(string_to_array(a.accessstringui ,',')) b
) uroles ON
	a.axp_cardsid = uroles.axp_cardsid
WHERE
	a.inhomepage = 'T'

>>

<<
CREATE OR REPLACE VIEW VW_CARDS_DASHBOARD AS 
  SELECT
	a.cardtype,
	a.cardname,
	a.cardicon,
	a.charttype,
	a.pluginname,
	CASE
		WHEN a.pluginname IS NULL THEN a.html_editor_card
		ELSE h.htmltext
	END AS htmltext,
	a.card_datasource,
	s.sqltext sqltext,
	a.width,
	a.height,
	a.autorefresh,
	uroles.role AS uroles,
	a.axp_cardsid,
	h.context,
	a.orderno,
	a.chartjson,ROW_NUMBER() over(PARTITION BY uroles.ROLE,CARDTYPE,cardname ORDER BY uroles.ROLE,CARDTYPE,cardname) rno
FROM
	axp_cards a
LEFT JOIN
ax_htmlplugins h ON
	a.pluginname = h."name"
LEFT JOIN
axdirectsql s ON
	a.card_datasource = s.sqlname
LEFT JOIN
(SELECT a.AXP_CARDSID, b.column_value role	FROM axp_cards a , table(string_to_array(a.accessstringui ,',')) b
) uroles ON
	a.axp_cardsid = uroles.axp_cardsid
WHERE
	a.indashboard = 'T'
>>

