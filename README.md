# Olist E-Commerce: State-Level Revenue & Delivery Risk Analysis

An end-to-end analysis combining **SQL, Python, and Power BI** to identify which states generate the most revenue for an e-commerce platform, whether those states are also experiencing poor delivery performance, and whether delivery delay is linked to customer review scores.

**Dataset:** [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (via PostgreSQL)
**Tools:** PostgreSQL, pgAdmin, Python (pandas), Power BI Desktop (DAX)

This is a companion project to [Project 1: SQL Cohort & RFM Analysis](#) (same dataset, different analytical focus).

---

## Problem

This analysis looks for a mismatch: states that generate strong revenue for the business, but may be quietly underperforming on delivery — a risk that could go unnoticed simply because the revenue numbers look healthy. It also examines whether delivery delays are linked to lower customer review scores, to test whether slow delivery is actually hurting customer satisfaction.

## Approach

1. **SQL (PostgreSQL):** Joined `orders`, `order_items`, `order_reviews`, and `customers` tables, filtered to delivered orders only, and exported the result. Used a `LEFT JOIN` on reviews (since not every order has one) and `INNER JOIN` on items/customers (mandatory relationships).
2. **Python (pandas):** Converted date columns, calculated `delivery_delay_days` (actual vs. estimated delivery date), created an `is_late` flag, handled missing values, and mapped state codes to full names for accurate geocoding.
3. **Power BI:** Built a two-page interactive dashboard (full analysis + executive summary) with KPI cards, a revenue map, a bar chart, a scatter plot, and DAX measures for revenue ranking and late delivery rate — including re-checking an initial finding against a second metric before finalizing the conclusion.

## Key Findings

**Overall picture:** Across ~96,000 delivered orders (R$13.28M total revenue from product price only — see Limitations), the average delivery delay is -12.03 days (orders arrive early on average) and the average review score is 4.02/5. The national late delivery rate is 6.8%.

1. **São Paulo**, the highest-revenue state (R$50.9L, ~38% of total revenue), performs well on delivery — its late delivery rate (4.5%) is well below the national average, despite a tighter average delivery cushion (-11.21 days) than most states.

2. **Rio de Janeiro**, the second-highest revenue state (R$17.7L, ~13% of revenue), has a late delivery rate of **12.1% — roughly 1.8x the national average.** Its average delivery delay (-12.00 days) looked slightly better than São Paulo's, so this problem was invisible on that metric alone — it only surfaced once late delivery rate was checked specifically.

3. **Bahia** (R$4.95L, ~4% of revenue) shows a nearly identical late rate to Rio (12.2%), making it a secondary state worth the same operational attention, though its smaller revenue share makes Rio the higher priority.

4. **Why this pattern likely occurs:** high-revenue states tend to be more accessible and densely populated, so promised delivery windows are tighter; remote states get more cautious (longer) windows, making them look better on average delay even though this isn't about delivery quality — it's about how conservative the estimate was.

5. **Late deliveries are strongly linked to lower review scores.** Orders delivered late received an average review of 2.53 out of 5, compared to 4.19 for on-time orders — a gap of nearly 1.7 stars across ~96,000 orders.

6. **Rio de Janeiro's own average review score (3.87) is only moderately below the national average (4.02)** — a smaller gap than the late/on-time split alone would suggest, since ~88% of Rio's orders are still on time. Delivery delay is likely one contributing factor to lower satisfaction in Rio, not the sole cause.

7. **Some states have far worse late delivery rates than Rio** — Alagoas (21.4%), Maranhão (17.4%), and Sergipe (15.2%) all exceed Rio's 12.1%. However, each contributes under 1% of total revenue, so despite worse delivery performance, the business impact of fixing them is minor compared to addressing Rio (revenue rank #2).

## Recommendation

The operations/logistics team should investigate the specific cause of Rio de Janeiro's elevated late delivery rate (12.1% vs. 6.8% national average) — since Rio is not a remote, hard-to-reach region like the states with the best delivery cushions, the usual "long distance" explanation likely doesn't apply, and the cause is more probably tied to something specific to Rio's operations: a particular warehouse, carrier, or local traffic/congestion pattern. Once the root cause is confirmed, targeted fixes (e.g., adjusting warehouse allocation, carrier partnerships, or delivery capacity in the region) can be considered — rather than committing to a broad, costly change before the actual cause is known.

## Estimated Business Impact

At Rio's current late delivery rate of 12.1%, roughly 1,452 of its ~12,000 annual orders arrive late. Bringing this down to the national average of 6.8% would reduce that to about 816 — a shift of approximately **636 orders from late to on-time each year**. Given that late orders average 2.53 stars versus 4.19 for on-time orders elsewhere in the dataset, these improved orders would likely see a meaningful review-score lift. This is a projection based on existing patterns, not a guarantee, but it gives the operations team a concrete, measurable target.

## Challenges & How They Were Solved

- **Duplicate review IDs blocked the SQL import** (789 of 99,224 reviews shared an ID across different orders — a real quirk in how Olist groups multi-seller purchases). Rather than deleting rows and losing legitimate order-level delivery data, the primary key constraint was dropped and the issue documented as an accepted, immaterial limitation (<1% of rows).
- **Power BI's map misplaced Brazilian states** (2-letter codes like "SP" were being geocoded as US/other regions). Fixed by mapping all 27 state codes to full names via a Python dictionary before re-loading into Power BI.
- **A KPI number drifted after several dashboard rebuilds** (Late Delivery Rate showed 6.8% instead of a previously-confirmed 6.1%). Diagnosed by ruling out stuck filters and data corruption, then cross-validating Power BI's measure against an independent Python calculation on the same data — which confirmed 6.8% was correct, and the earlier 6.1% had been captured during an unstable mid-rebuild state. Every affected number across the dashboard and write-up was corrected.

## Limitations

- **Duplicate reviews:** 789 of 99,224 reviews (<1%) were linked to more than one order; kept as-is to avoid deleting legitimate order-level delivery data.
- **Missing delivery dates:** 8 of 110,840 "delivered" orders (~0.007%) had no delivery date and were excluded.
- **Correlation, not proven causation:** the delay–review relationship is a strong, consistent pattern, but other factors (product quality, pricing, customer service) likely also influence review scores.
- **No root-cause data for Rio's delay:** the dataset lacks carrier, warehouse, or route-level detail, so the recommendation calls for further investigation rather than a specific fix.
- **Possible review non-response bias:** only orders with a submitted review are included in review-score averages, which could understate or overstate the true impact of late delivery on satisfaction.
- **No outlier check on delivery delay:** extreme values were not specifically checked for and could influence state-level averages.
- **Revenue excludes shipping cost:** "Total Revenue" reflects product price only, not the freight/shipping amount customers actually paid.

## What I'd Explore With More Time

- A date-range filter for trend analysis over time — deferred because the business question centers on state-level patterns, not time trends, and the purchase-date field wasn't part of the original data pull.
- Product category breakdown — out of scope for this state-focused question, but would help answer "which product categories drive this delay pattern."

## AI Usage Disclosure

I used Claude (Anthropic) as a learning tool throughout this project — to explain SQL, pandas, and DAX concepts step by step, review my own attempts at queries/code/formulas, and help structure this write-up. Every query, calculation, and conclusion was written, run, and verified by me against the actual data; Claude did not generate final answers for me to copy. Notably, an initial AI-assisted interpretation of the data (based on average delivery delay alone) was later corrected after I built an additional metric (late delivery rate) that changed the conclusion — a reminder to verify any single metric against a second one before finalizing an insight.

## Repository Contents

- `sql/data_pull.sql` — table creation and the final data extraction query
- `python/clean_data.ipynb` — data cleaning, delay calculation, and state-name mapping
- `powerbi/Project2_Dashboard.pbix` — two-page interactive dashboard
- `Project2_Key_Findings_and_Recommendation.md` — standalone findings document
