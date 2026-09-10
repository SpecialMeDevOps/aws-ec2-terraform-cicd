from datetime import datetime, timezone

import streamlit as st


st.set_page_config(
    page_title="CloudDeploy | Streamlit App",
    page_icon="☁️",
    layout="wide",
    initial_sidebar_state="collapsed",
)

st.markdown(
    """
    <style>
      .stApp {
        background: linear-gradient(135deg, #0b1120 0%, #172554 100%);
      }
      .hero {
        background: radial-gradient(circle at top right, #2563eb, #111827 60%);
        border-radius: 18px;
        color: #f8fafc;
        margin-bottom: 28px;
        padding: 48px;
      }
      .hero h1 { font-size: 3.4rem; margin: 0 0 16px; }
      .hero h1 span { color: #93c5fd; }
      .hero p { color: #dbeafe; font-size: 1.15rem; line-height: 1.7; }
      .badge {
        background: #166534;
        border-radius: 999px;
        color: #dcfce7;
        display: inline-block;
        font-size: .85rem;
        font-weight: 700;
        margin-bottom: 18px;
        padding: 8px 14px;
      }
      .card {
        background: rgba(15, 23, 42, .82);
        border: 1px solid #334155;
        border-radius: 12px;
        min-height: 125px;
        padding: 22px;
      }
      .card h3 { color: #bfdbfe; margin-top: 0; }
      .card p { color: #cbd5e1; }
    </style>
    """,
    unsafe_allow_html=True,
)

st.markdown(
    """
    <section class="hero">
      <div class="badge">● All systems operational</div>
      <h1>Build fast.<br><span>Deploy smarter.</span></h1>
      <p>
        A production-ready Streamlit application running in Docker on AWS EC2,
        provisioned automatically with Terraform.
      </p>
    </section>
    """,
    unsafe_allow_html=True,
)

first, second, third = st.columns(3)
with first:
    st.markdown(
        '<div class="card"><h3>🐍 Streamlit</h3>'
        "<p>Interactive Python frontend with a clean dashboard experience.</p></div>",
        unsafe_allow_html=True,
    )
with second:
    st.markdown(
        '<div class="card"><h3>🐳 Docker</h3>'
        "<p>Portable and consistent application runtime.</p></div>",
        unsafe_allow_html=True,
    )
with third:
    st.markdown(
        '<div class="card"><h3>☁️ AWS EC2</h3>'
        "<p>Cloud infrastructure managed by Terraform and CI/CD.</p></div>",
        unsafe_allow_html=True,
    )

st.divider()
st.subheader("Deployment status")
status_col, time_col = st.columns(2)
with status_col:
    st.metric("Application", "Healthy", "Running")
with time_col:
    st.metric(
        "Last checked",
        datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
    )

if st.button("Refresh status", type="primary"):
    st.rerun()
