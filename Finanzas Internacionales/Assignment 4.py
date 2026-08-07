import numpy as np
import matplotlib.pyplot as plt

# Assumed structural parameters for the representation (must satisfy 0 < parameter < 1)
mu1 = 0.6      # Relative power of workers
mu2 = 0.4      # Degree of wage indexation
phi1 = 0.5     # Price sensitivity to the wage gap
phi2 = 0.3     # Pass-through of unit labor costs to prices
phi3 = 0.4     # Exchange rate pass-through degree
a_hat = 0.02   # Labor productivity growth
omega_W = 0.75 # Workers' wage share target
omega_F = 0.40 # Firms' implicit wage share target

# Nominal exchange rate scenarios (e_hat)
e_hat_base = 0.00   # Baseline scenario without devaluation
e_hat_shock = 0.15  # Exogenous shock (devaluation)

# Wage share (omega) range for plotting
omega = np.linspace(0.3, 0.8, 200)

# Equations for the P_W and P_F curves derived analytically
def curve_Pw(w):
    return (mu1 * (omega_W - w) - a_hat) / (1 - mu2)

def curve_Pf(w, e):
    return (phi1 * (w - omega_F) + phi3 * e) / (1 - phi2)

# Calculation of the curves
pw_vals = curve_Pw(omega)
pf_base_vals = curve_Pf(omega, e_hat_base)
pf_shock_vals = curve_Pf(omega, e_hat_shock)

# Algebraic determination of equilibrium points
eq_denominator = (1 - mu2)*phi1 + (1 - phi2)*mu1

# Equilibrium 1 (Baseline)
numerator_w1 = (1 - mu2)*phi1*omega_F + (1 - phi2)*mu1*omega_W - (1 - phi2)*a_hat - (1 - mu2)*phi3*e_hat_base
omega_star1 = numerator_w1 / eq_denominator
p_star1 = curve_Pw(omega_star1)

# Equilibrium 2 (Post-Devaluation)
numerator_w2 = (1 - mu2)*phi1*omega_F + (1 - phi2)*mu1*omega_W - (1 - phi2)*a_hat - (1 - mu2)*phi3*e_hat_shock
omega_star2 = numerator_w2 / eq_denominator
p_star2 = curve_Pw(omega_star2)

# --- Plot Generation ---
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# Plot 1: Initial Equilibrium
ax1.plot(omega, pw_vals, label='Pw (Wage bargaining)', color='blue', linewidth=2)
ax1.plot(omega, pf_base_vals, label='Pf (Price setting)', color='red', linewidth=2)
ax1.scatter([omega_star1], [p_star1], color='black', zorder=5)
ax1.annotate('A', (omega_star1, p_star1), xytext=(5, 5), textcoords='offset points', fontsize=12, fontweight='bold')
ax1.axvline(x=omega_star1, color='grey', linestyle='--', alpha=0.5)
ax1.axhline(y=p_star1, color='grey', linestyle='--', alpha=0.5)

ax1.set_title('Initial Equilibrium (No exchange rate shock)')
ax1.set_xlabel('Wage Share ($\omega$)')
ax1.set_ylabel('Inflation ($\hat{p}$)')
ax1.set_xlim(0.35, 0.75)
ax1.set_ylim(-0.1, 0.6)
ax1.grid(True, alpha=0.3)
ax1.legend()

# Plot 2: Impact of Devaluation
ax2.plot(omega, pw_vals, label='Pw', color='blue', linewidth=2)
ax2.plot(omega, pf_base_vals, label='Initial Pf', color='red', linewidth=2, alpha=0.3)
ax2.plot(omega, pf_shock_vals, label="Pf' (Post-devaluation)", color='darkred', linestyle='--', linewidth=2)

ax2.scatter([omega_star1], [p_star1], color='black', alpha=0.4, zorder=5)
ax2.annotate('A', (omega_star1, p_star1), xytext=(5, 5), textcoords='offset points', fontsize=12, alpha=0.6)
ax2.scatter([omega_star2], [p_star2], color='black', zorder=5)
ax2.annotate('B', (omega_star2, p_star2), xytext=(5, 5), textcoords='offset points', fontsize=12, fontweight='bold')

# Displacement guide lines
ax2.axvline(x=omega_star1, color='grey', linestyle=':', alpha=0.5)
ax2.axhline(y=p_star1, color='grey', linestyle=':', alpha=0.5)
ax2.axvline(x=omega_star2, color='black', linestyle='--', alpha=0.5)
ax2.axhline(y=p_star2, color='black', linestyle='--', alpha=0.5)

ax2.set_title("Impact of a Devaluation (Increase in $\hat{e}$)")
ax2.set_xlabel('Wage Share ($\omega$)')
ax2.set_ylabel('Inflation ($\hat{p}$)')
ax2.set_xlim(0.35, 0.75)
ax2.set_ylim(-0.1, 0.6)
ax2.grid(True, alpha=0.3)
ax2.legend()

plt.tight_layout()
plt.show()
