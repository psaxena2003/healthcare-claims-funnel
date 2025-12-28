# Healthcare Claims Exploratory Data Analysis (EDA)

## 📌 Project Overview
This project focuses on **exploratory data analysis (EDA)** of healthcare insurance claims to understand
claim outcomes, approval and denial patterns, operational delays, and financial leakage.

Instead of treating claims as a strict funnel, the analysis explores **drivers behind approvals and denials**,
provider-level risk, processing efficiency, and potential revenue loss, enabling data-driven decision-making.

---

## 🎯 Objectives
- Analyze approval vs denial outcomes of healthcare claims
- Identify high-risk providers and denial patterns
- Quantify revenue leakage from partially approved claims
- Evaluate adjudication and payment delays
- Surface data quality and audit exceptions

---

## 🗂 Dataset Description
The dataset contains anonymized healthcare claim records, including:
- Claim and patient identifiers
- Provider information
- Claim and approved amounts
- Claim outcomes (Approved / Denied)
- Processing timelines
- Denial reasons and audit flags

> ⚠️ Raw data is excluded from this repository for privacy and compliance reasons.

---

## 🛠 Tech Stack
- **Python**: Data cleaning and preprocessing
- **SQLite**: Lightweight analytics database
- **SQL**: Exploratory and business analysis queries
- **Power BI**: Interactive dashboards and insights
- **GitHub**: Version control and project collaboration

---

## 📊 Key Analyses Performed
- Approval vs denial distribution
- Provider-level denial and approval rates
- Revenue leakage estimation
- Average adjudication and payment delays
- Denial reason analysis
- Monthly trends in claim outcomes
- Audit checks (approved-but-not-paid, denied-but-paid)

---

## 📈 Dashboard Highlights (Power BI)
- Executive summary KPIs (Approval Rate, Revenue Leakage)
- Outcome distribution by provider and time
- Risk and denial analysis
- Operational efficiency metrics

---

## 🧠 Key Takeaways
- A small set of providers contributes disproportionately to claim denials
- Revenue leakage highlights optimization opportunities in claim approvals
- Operational delays directly impact payment timelines
- EDA provides deeper insights than a forced funnel model for this dataset

---

## 🚀 Future Enhancements
- Predictive modeling for claim denial risk
- Provider benchmarking dashboards
- SLA-based alerting for delayed payments
