# Project 2: End-to-End Business Analysis with Power BI
## Key Findings & Recommendation

---

### Problem

This analysis looks for a mismatch: states that generate strong revenue for the business, but may be quietly underperforming on delivery — a risk that could go unnoticed simply because the revenue numbers look healthy. It also examines whether delivery delays are linked to lower customer review scores, to test whether slow delivery is actually hurting customer satisfaction.

---

### Approach

I pulled and joined order, customer, and review data using SQL, calculated delivery delay and a late/on-time flag in Python, then built an interactive Power BI dashboard with KPI cards, a map, a bar chart, and a scatter plot. I used DAX measures to compare revenue and delivery performance across states — including checking my initial finding against a second metric (late delivery rate) before finalizing the conclusion, to avoid drawing conclusions from a single, potentially misleading average.

---

### Key Findings

**Overall picture:** Across ~96,000 delivered orders (R$13.28M total revenue from product price only — see Limitations), the average delivery delay is -12.03 days (orders arrive early on average) and the average review score is 4.02/5. The national late delivery rate is 6.8%.

1. **São Paulo, the highest-revenue state (R$50.9L, ~38% of total revenue), performs well on delivery** — its late delivery rate (4.5%) is well below the national average, despite a tighter average delivery cushion (-11.21 days) than most states.

2. **Rio de Janeiro, the second-highest revenue state (R$17.7L, ~13% of revenue), has a late delivery rate of 12.1% — roughly 1.8x the national average.** Its average delivery delay (-12.00 days) looked slightly better than São Paulo's (-11.21), so this problem was invisible on that metric alone — it only surfaced once late delivery rate was checked specifically.

3. **Bahia (R$4.95L, ~4% of revenue) shows a nearly identical late rate to Rio (12.2%)**, making it a secondary state worth the same operational attention, though its smaller revenue share makes Rio the higher priority.

4. **Why this pattern likely occurs:** high-revenue states tend to be more accessible and densely populated, so promised delivery windows are tighter; remote states get more cautious (longer) windows, making them look better on average delay even though this isn't about delivery quality — it's about how conservative the estimate was.

5. **Late deliveries are strongly linked to lower review scores.** Orders delivered late received an average review of 2.53 out of 5, compared to 4.19 for on-time orders — a gap of nearly 1.7 stars across ~96,000 orders. A score of 2.53 sits below the midpoint of the scale, meaning late orders don't just score slightly worse, they tend to be rated genuinely poorly.

6. **Rio de Janeiro's own average review score (3.87) is only moderately below the national average (4.02)** — a smaller gap than the late/on-time split alone would suggest, since ~88% of Rio's orders are still on time. Delivery delay is likely one contributing factor to lower satisfaction in Rio, not the sole cause.

7. **Some states have far worse late delivery rates than Rio** — Alagoas (21.4%), Maranhão (17.4%), and Sergipe (15.2%) all exceed Rio's 12.1%. However, these states each contribute under 1% of total revenue, so despite worse delivery performance, the business impact of fixing them is minor compared to addressing Rio (revenue rank #2).

---

### Recommendation

The operations/logistics team should investigate the specific cause of Rio de Janeiro's elevated late delivery rate (12.1% vs. 6.8% national average — roughly 1.8x) — since Rio is not a remote, hard-to-reach region like the states with the best delivery cushions, the usual "long distance" explanation likely doesn't apply, and the cause is more probably tied to something specific to Rio's operations: a particular warehouse, carrier, or local traffic/congestion pattern. Once the root cause is confirmed, targeted fixes (e.g., adjusting warehouse allocation, carrier partnerships, or delivery capacity in the region) can be considered — rather than committing to a broad, costly change before the actual cause is known.

---

### Estimated Business Impact

At Rio's current late delivery rate of 12.1%, roughly 1,452 of its ~12,000 annual orders arrive late. Bringing this down to the national average of 6.8% would reduce that to about 816 — a shift of approximately 636 orders from late to on-time each year. Given that late orders average 2.53 stars versus 4.19 for on-time orders elsewhere in the dataset, these improved orders would likely see a meaningful review-score lift. This is a projection based on existing patterns, not a guarantee, but it gives the operations team a concrete, measurable target.

---

### Limitations

- **Duplicate reviews:** 789 of 99,224 reviews (<1%) were linked to more than one order, likely due to how Olist's platform groups multi-seller purchases. Kept as-is rather than removed, to avoid deleting legitimate order-level delivery data.
- **Missing delivery dates:** 8 of 110,840 "delivered" orders (~0.007%) had no delivery date and were excluded, since no delay could be calculated for them.
- **Correlation, not proven causation:** the delay–review relationship is a strong, consistent pattern, but other factors (product quality, pricing, customer service) likely also influence review scores.
- **No root-cause data for Rio's delay:** the dataset lacks carrier, warehouse, or route-level detail, so the recommendation calls for further investigation rather than a specific fix.
- **Possible review non-response bias:** only orders with a submitted review are included in review-score averages. If customers with the worst experiences are less likely to leave a review at all, the true impact of late delivery on satisfaction could be understated or overstated.
- **No outlier check on delivery delay:** extreme values (e.g., a single severely delayed or data-error order) were not specifically checked for and could influence state-level averages.
- **Revenue excludes shipping cost:** "Total Revenue" reflects product price only (`order_items.price`), not the freight/shipping amount customers actually paid, understating total transaction value.

---

### What I'd Explore With More Time

- **A date-range filter** for trend analysis over time — deferred because the business question centers on state-level patterns, not time trends, and the purchase-date field wasn't part of the original data pull. Would revisit if the question shifted toward "how is this changing over time."
- **Product category breakdown** — out of scope for this state-focused question. Would revisit if the question shifted toward "which product categories drive this delay pattern."
