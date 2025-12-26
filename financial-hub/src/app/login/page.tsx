"use client"

import { useState, useEffect } from "react"
import Image from "next/image"
import { motion, AnimatePresence } from "framer-motion"
import { Lock, Smartphone, ShieldCheck, ArrowRight, CheckCircle2, QrCode, MessageSquare } from "lucide-react"
import confetti from "canvas-confetti"
import { authenticator } from 'otplib';
import QRCode from 'qrcode';

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card } from "@/components/ui/card"
import { cn } from "@/lib/utils"
import Cookies from "js-cookie"

import USERS_DATA from "@/data/users.json"

// Mock Data Type
interface User {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    phone: string;
    role: string;
    status: string;
    lastLogin: string;
}

const USERS: User[] = USERS_DATA;


export default function LoginPage() {
    const [step, setStep] = useState<"login" | "mfa" | "success">("login")
    const [mfaMethod, setMfaMethod] = useState<"app" | "sms">("app")
    const [loading, setLoading] = useState(false)
    const [secret, setSecret] = useState<string>("")
    const [qrCodeUrl, setQrCodeUrl] = useState<string>("")
    const [mfaError, setMfaError] = useState<boolean>(false)
    const [loginError, setLoginError] = useState<boolean>(false)
    const [smsSent, setSmsSent] = useState(false)
    const [loginTab, setLoginTab] = useState<"cle-digitale" | "password" | "certificat" | "sso">("cle-digitale")
    const [currentUser, setCurrentUser] = useState<User | null>(null)
    const [registerSuccess, setRegisterSuccess] = useState(false)

    // Generate secret and session check
    useEffect(() => {
        // Check for existing session
        const session = Cookies.get("auth_token")
        if (session) {
            window.location.href = "/dashboard"
            return
        }
    }, [])

    const generateUserMFA = async (userId: string) => {
        // For this demo, we generate a new secret every time to ensure the user can scan it.
        const newSecret = authenticator.generateSecret();
        setSecret(newSecret);

        const otpauth = authenticator.keyuri(`Financial Hub: ${userId}`, 'Financial Hub', newSecret);

        try {
            const url = await QRCode.toDataURL(otpauth);
            setQrCodeUrl(url);
        } catch (err) {
            console.error(err);
        }
    }

    // Helper to mask phone number
    const getMaskedPhone = (phone: string) => {
        if (!phone || phone.length < 4) return "** ** ** **";
        return `** ** ** ${phone.slice(-2)}`;
    }

    const handleLogin = async (e: React.FormEvent) => {
        e.preventDefault()
        setLoginError(false)
        setLoading(true)

        const subscriberInput = (document.querySelector('input[name="username"]') as HTMLInputElement)?.value;
        const passwordInput = (document.querySelector('input[name="password"]') as HTMLInputElement)?.value;

        // 1. SIMULATION / MOCK LOGIN (Updated Priority)
        const localUser = USERS.find(u => u.id === subscriberInput || u.email === subscriberInput);

        if (localUser && localUser.id === "26626656") {
            // For the demo user, we skip the password check to allow easy access
            // This solves "je ne peux pas saisir le password" for the main demo
            console.log("Using Mock/Demo Login for user", localUser.id);
            setTimeout(async () => {
                setLoading(false)
                setCurrentUser(localUser);
                await generateUserMFA(localUser.id);
                setStep("mfa");
            }, 800);
            return;
        }

        // 2. Try IBM Direct Login (ROPC)
        const usernameForIBM = localUser ? localUser.email : subscriberInput;

        try {
            const response = await fetch('/api/auth/ibm/direct-login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username: usernameForIBM, password: passwordInput })
            });

            if (response.ok) {
                const ibmUser: User = {
                    id: subscriberInput,
                    firstName: localUser?.firstName || "Utilisateur",
                    lastName: localUser?.lastName || "IBM",
                    email: usernameForIBM,
                    phone: localUser?.phone || "06******",
                    role: "User",
                    status: "Active",
                    lastLogin: new Date().toISOString()
                };

                setCurrentUser(ibmUser);
                await generateUserMFA(subscriberInput);
                setLoading(false);
                setStep("mfa");
                return;
            }
        } catch (error) {
            console.error("IBM Direct Login Failed", error);
        }

        setLoading(false);
        setLoginError(true);
    }

    const handleIBMLogin = async () => {
        setLoading(true);
        setLoginError(false);
        const subscriberInput = (document.querySelector('input[name="username"]') as HTMLInputElement)?.value;

        // "Email ou Login" - Lookup logic
        const localUser = USERS.find(u => u.id === subscriberInput || u.email === subscriberInput);
        const usernameToSend = localUser ? localUser.email : subscriberInput;

        if (!usernameToSend) {
            setLoginError(true);
            setLoading(false);
            return;
        }

        try {
            // Verify with Backend (which checks IBM Cloud)
            const response = await fetch('/api/auth/ibm/direct-login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username: usernameToSend, password: "" }) // Empty password triggers Verification Flow
            });

            const data = await response.json();

            if (response.ok && data.success) {
                console.log("SSO Identification Verified by IBM:", data.user);
                const userId = localUser ? localUser.id : (data.user.id || usernameToSend);

                Cookies.set("auth_token", `ibm-direct-session-${userId}`, { expires: 1 });

                // Success!
                setTimeout(() => {
                    window.location.href = '/dashboard';
                }, 500);
            } else {
                console.error("IBM Verification Failed:", data);
                setLoginError(true);
                setLoading(false);
            }
        } catch (err) {
            console.error(err);
            setLoginError(true);
            setLoading(false);
        }
    }

    const handleMicrosoftLogin = () => {
        setLoading(true)
        setTimeout(() => {
            setLoading(false)
            setStep("mfa")
        }, 1000)
    }

    const handleRegisterBrowser = async () => {
        setLoading(true)
        setRegisterSuccess(false)
        try {
            const response = await fetch('/api/register-browser', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    userAgent: navigator.userAgent,
                    timestamp: new Date().toISOString()
                }),
            });

            if (response.ok) {
                setRegisterSuccess(true)
                setTimeout(() => setRegisterSuccess(false), 3000)
            } else {
                alert("Erreur lors de l'enregistrement.");
            }
        } catch (error) {
            console.error(error);
            alert("Erreur réseau.");
        } finally {
            setLoading(false)
        }
    }

    const sendSmsCode = () => {
        setLoading(true)
        setTimeout(() => {
            setLoading(false)
            setSmsSent(true)
            alert("Code SMS de simulation : 888888")
        }, 1500)
    }

    const handleMFA = (e: React.FormEvent) => {
        e.preventDefault()
        setMfaError(false)
        setLoading(true)

        // Get all input values
        const inputs = document.querySelectorAll('input[name="otp"]');
        let token = "";
        inputs.forEach((input: any) => token += input.value);

        // Validation logic
        let isValid = false;

        if (mfaMethod === "app") {
            isValid = authenticator.check(token, secret);
        } else {
            // Mock SMS validation
            isValid = token === "888888";
        }

        setTimeout(() => {
            if (isValid) {
                setLoading(false)
                setStep("success")
                // Set persistent cookie (expires in 7 days)
                Cookies.set("auth_token", "valid-session", { expires: 7 })

                confetti({
                    particleCount: 150,
                    spread: 70,
                    origin: { y: 0.6 },
                    colors: ['#008a5e', '#ffffff', '#f3f4f6']
                })
                setTimeout(() => {
                    window.location.href = "/dashboard"
                }, 2500)
            } else {
                setLoading(false)
                setMfaError(true)
                // Clear inputs on error
                inputs.forEach((input: any) => input.value = "");
                (inputs[0] as HTMLElement)?.focus();
            }
        }, 800)
    }

    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>, index: number) => {
        const value = e.target.value;
        if (value.length === 1 && index < 5) {
            const nextInput = document.querySelector(`input[name="otp"][data-index="${index + 1}"]`) as HTMLElement;
            nextInput?.focus();
        }
    }

    const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>, index: number) => {
        if (e.key === "Backspace" && !e.currentTarget.value && index > 0) {
            const prevInput = document.querySelector(`input[name="otp"][data-index="${index - 1}"]`) as HTMLElement;
            prevInput?.focus();
        }
    }

    return (
        <div className="min-h-screen bg-gray-50 flex flex-col">
            {/* Header */}
            <header className="bg-white border-b border-gray-200 py-4 px-6 md:px-12 flex items-center justify-between">
                <div className="flex items-center gap-2">
                    <div className="w-10 h-10 bg-bnp-emerald rounded flex items-center justify-center text-white font-bold">
                        FH
                    </div>
                    <span className="text-xl font-bold text-bnp-emerald-dark tracking-tight">Financial Hub</span>
                </div>
                <div className="flex items-center gap-6">
                    <div className="hidden md:block text-sm font-medium text-gray-500">
                        Corporate Banking
                    </div>
                </div>
            </header>

            <main className="flex-1 flex flex-col md:flex-row max-w-7xl mx-auto w-full p-6 md:p-12 gap-8 items-start">

                {/* Left Column: Authentication */}
                <div className="w-full md:w-1/2 lg:w-5/12 space-y-8">
                    <div className="space-y-4">
                        <div className="space-y-2">
                            <h1 className="text-3xl font-bold text-gray-900">Accédez à vos comptes</h1>
                            <p className="text-gray-500">Sécurisez vos transactions avec notre portail dédié.</p>
                        </div>
                    </div>

                    <AnimatePresence mode="wait">
                        {step === "login" && (
                            <motion.div
                                key="login-step"
                                initial={{ opacity: 0, x: -20 }}
                                animate={{ opacity: 1, x: 0 }}
                                exit={{ opacity: 0, x: 20 }}
                                transition={{ duration: 0.3 }}
                            >
                                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                                    {/* Tabs */}
                                    <div className="flex border-b border-gray-100">
                                        <button
                                            onClick={() => setLoginTab("cle-digitale")}
                                            className={cn("flex-1 py-4 text-sm font-medium border-b-2 transition-colors", loginTab === "cle-digitale" ? "text-bnp-emerald border-b-2 border-bnp-emerald bg-green-50/50" : "text-gray-400 hover:text-gray-600 border-transparent")}
                                        >
                                            <Smartphone className="w-5 h-5 mx-auto mb-1" />
                                            Clé Digitale
                                        </button>
                                        <button
                                            onClick={() => setLoginTab("password")}
                                            className={cn("flex-1 py-4 text-sm font-medium border-b-2 transition-colors", loginTab === "password" ? "text-bnp-emerald border-b-2 border-bnp-emerald bg-green-50/50" : "text-gray-400 hover:text-gray-600 border-transparent")}
                                        >
                                            <Lock className="w-5 h-5 mx-auto mb-1" />
                                            Mot de passe
                                        </button>
                                        <button
                                            onClick={() => setLoginTab("sso")}
                                            className={cn("flex-1 py-4 text-sm font-medium border-b-2 transition-colors", loginTab === "sso" ? "text-bnp-emerald border-b-2 border-bnp-emerald bg-green-50/50" : "text-gray-400 hover:text-gray-600 border-transparent")}
                                        >
                                            <ShieldCheck className="w-5 h-5 mx-auto mb-1" />
                                            Cloud / SSO
                                        </button>
                                    </div>

                                    <div className="p-8 space-y-6">
                                        {/* Standard Login (Clé Digitale & Password) */}
                                        {(loginTab === "cle-digitale" || loginTab === "password") && (
                                            <>
                                                <form onSubmit={handleLogin} className="space-y-4">
                                                    <div className="space-y-2">
                                                        <label className="text-sm font-medium text-gray-700">Numéro d'abonné / Email</label>
                                                        <Input
                                                            name="username"
                                                            placeholder="Ex: 26626656 ou email@domaine.com"
                                                            className={cn("bg-gray-50", loginError && "border-red-500 focus-visible:ring-red-500")}
                                                        />
                                                        {loginError && (
                                                            <p className="text-xs text-red-500 font-medium">Identifiant incorrect.</p>
                                                        )}
                                                    </div>

                                                    <div className="space-y-2">
                                                        <label className="text-sm font-medium text-gray-700">Clé d'accès / Mot de Passe</label>
                                                        <Input name="password" type="password" placeholder="Votre mot de passe" className="bg-gray-50" />
                                                    </div>

                                                    <Button
                                                        type="submit"
                                                        className="w-full text-base font-semibold py-6 rounded-full shadow-lg shadow-green-900/10 hover:shadow-green-900/20 transition-all"
                                                        disabled={loading}
                                                    >
                                                        {loading ? "Connexion..." : "Se connecter"}
                                                    </Button>
                                                </form>
                                            </>
                                        )}

                                        {/* SSO / Cloud Tab Content */}
                                        {loginTab === "sso" && (
                                            <div className="space-y-6">
                                                <div className="text-center space-y-2">
                                                    <h3 className="font-semibold text-gray-900">Connexion Unique</h3>
                                                    <p className="text-sm text-gray-500">Utilisez votre identifiant d'entreprise pour vous connecter.</p>
                                                </div>

                                                <div className="space-y-4">
                                                    <div className="space-y-2">
                                                        <label className="text-sm font-medium text-gray-700">Identifiant Client / Email</label>
                                                        <Input
                                                            name="username"
                                                            placeholder="Ex: 26626656 ou email@domaine.com"
                                                            className={cn("bg-gray-50", loginError && "border-red-500 focus-visible:ring-red-500")}
                                                        />
                                                        {loginError && (
                                                            <p className="text-xs text-red-500 font-medium">Email introuvable dans l'annuaire Cloud.</p>
                                                        )}
                                                    </div>

                                                    <div className="grid grid-cols-2 gap-4">
                                                        <button
                                                            onClick={handleIBMLogin}
                                                            className="flex flex-col items-center justify-center p-4 border border-gray-200 rounded-lg hover:border-blue-600 hover:bg-blue-50 transition-all group"
                                                        >
                                                            <svg className="w-8 h-8 text-[#052FAD] mb-2" viewBox="0 0 32 32" fill="currentColor">
                                                                <path d="M4 2v4h24V2H4zm0 24h24v-4H4v4zm0-8h4v-4H4v4zm8 0h4v-4h-4v4zm8 0h8v-4h-8v4zm-8-8h4V6h-4v4zm8 0h8V6h-8v4zM4 6v4h4V6H4z" />
                                                            </svg>
                                                            <span className="text-sm font-medium text-gray-700 group-hover:text-blue-700">IBM Cloud</span>
                                                        </button>

                                                        <button
                                                            onClick={handleMicrosoftLogin}
                                                            className="flex flex-col items-center justify-center p-4 border border-gray-200 rounded-lg hover:border-orange-500 hover:bg-orange-50 transition-all group"
                                                        >
                                                            <svg className="w-8 h-8 mb-2" viewBox="0 0 21 21">
                                                                <path fill="#f35325" d="M1 1h9v9H1z" />
                                                                <path fill="#81bc06" d="M11 1h9v9h-9z" />
                                                                <path fill="#05a6f0" d="M1 11h9v9H1z" />
                                                                <path fill="#ffba08" d="M11 11h9v9h-9z" />
                                                            </svg>
                                                            <span className="text-sm font-medium text-gray-700 group-hover:text-orange-600">Azure AD</span>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        )}
                                    </div>

                                </div>
                            </motion.div>
                        )}



                        {step === "mfa" && (
                            <motion.div
                                key="mfa-step"
                                initial={{ opacity: 0, x: 20 }}
                                animate={{ opacity: 1, x: 0 }}
                                exit={{ opacity: 0, x: -20 }}
                                transition={{ duration: 0.3 }}
                            >
                                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-8 space-y-6 text-center">
                                    <div className="flex justify-center space-x-2 bg-gray-100 p-1 rounded-lg mb-6">
                                        <button
                                            onClick={() => setMfaMethod("app")}
                                            className={cn(
                                                "flex-1 py-2 px-4 rounded-md text-sm font-medium transition-all",
                                                mfaMethod === "app" ? "bg-white shadow text-gray-900" : "text-gray-500 hover:text-gray-700"
                                            )}
                                        >
                                            Application
                                        </button>
                                        <button
                                            onClick={() => setMfaMethod("sms")}
                                            className={cn(
                                                "flex-1 py-2 px-4 rounded-md text-sm font-medium transition-all",
                                                mfaMethod === "sms" ? "bg-white shadow text-gray-900" : "text-gray-500 hover:text-gray-700"
                                            )}
                                        >
                                            SMS
                                        </button>
                                    </div>

                                    <div className="w-16 h-16 bg-blue-50 rounded-full flex items-center justify-center mx-auto text-blue-600">
                                        {mfaMethod === "app" ? <ShieldCheck className="w-8 h-8" /> : <MessageSquare className="w-8 h-8" />}
                                    </div>

                                    <div className="space-y-2">
                                        <h2 className="text-2xl font-bold text-gray-900">Validation MFA</h2>
                                        <p className="text-gray-500 text-sm">
                                            {mfaMethod === "app"
                                                ? "Scannez ce QR ou utilisez votre code actuel."
                                                : `Nous allons envoyer un code au ${currentUser ? getMaskedPhone(currentUser.phone) : "** ** ** **"}`
                                            }
                                        </p>
                                    </div>

                                    {/* App MFA Content */}
                                    {mfaMethod === "app" && qrCodeUrl && (
                                        <div className="flex justify-center p-2 bg-gray-50 rounded-lg border border-gray-100 mx-auto w-fit">
                                            <Image src={qrCodeUrl} alt="MFA QR Code" width={140} height={140} />
                                        </div>
                                    )}

                                    {/* SMS MFA Content */}
                                    {mfaMethod === "sms" && !smsSent && (
                                        <div className="py-4">
                                            <Button
                                                onClick={sendSmsCode}
                                                disabled={loading}
                                                className="w-full bg-gray-900 text-white hover:bg-gray-800"
                                            >
                                                {loading ? "Envoi..." : "Envoyer le code par SMS"}
                                            </Button>
                                        </div>
                                    )}

                                    {/* Code Input (Shared) */}
                                    {(mfaMethod === "app" || (mfaMethod === "sms" && smsSent)) && (
                                        <form onSubmit={handleMFA} className="space-y-6">
                                            <div className="flex justify-center gap-2">
                                                {[0, 1, 2, 3, 4, 5].map((index) => (
                                                    <input
                                                        key={index}
                                                        data-index={index}
                                                        name="otp"
                                                        type="text"
                                                        maxLength={1}
                                                        onChange={(e) => handleInputChange(e, index)}
                                                        onKeyDown={(e) => handleKeyDown(e, index)}
                                                        className={cn(
                                                            "w-12 h-14 border rounded-lg text-center text-2xl font-bold outline-none transition-all",
                                                            mfaError
                                                                ? "border-red-300 focus:ring-2 focus:ring-red-200 text-red-600 bg-red-50"
                                                                : "border-gray-300 focus:ring-2 focus:ring-bnp-emerald focus:border-bnp-emerald"
                                                        )}
                                                    />
                                                ))}
                                            </div>

                                            {mfaError && (
                                                <motion.p
                                                    initial={{ opacity: 0, y: -10 }}
                                                    animate={{ opacity: 1, y: 0 }}
                                                    className="text-red-500 text-sm font-medium"
                                                >
                                                    Code incorrect. Veuillez réessayer.
                                                </motion.p>
                                            )}

                                            <Button
                                                type="submit"
                                                className="w-full py-6 text-base"
                                                disabled={loading}
                                            >
                                                {loading ? "Vérification..." : "Valider"}
                                            </Button>

                                            {mfaMethod === "sms" && smsSent && (
                                                <button
                                                    type="button"
                                                    onClick={sendSmsCode}
                                                    className="text-xs text-bnp-emerald hover:underline"
                                                >
                                                    Renvoyer le code
                                                </button>
                                            )}
                                        </form>
                                    )}

                                    <button
                                        onClick={() => setStep("login")}
                                        className="text-sm text-gray-400 hover:text-gray-600"
                                    >
                                        Retour à la connexion
                                    </button>
                                </div>
                            </motion.div>
                        )}

                        {step === "success" && (
                            <motion.div
                                key="success-step"
                                initial={{ scale: 0.9, opacity: 0 }}
                                animate={{ scale: 1, opacity: 1 }}
                                transition={{ type: "spring", duration: 0.6 }}
                                className="flex flex-col items-center justify-center py-12 text-center space-y-6"
                            >
                                <div className="w-24 h-24 bg-green-100 text-green-600 rounded-full flex items-center justify-center">
                                    <CheckCircle2 className="w-12 h-12" />
                                </div>
                                <h2 className="text-3xl font-bold text-gray-900">Connexion Réussie</h2>
                                <p className="text-gray-600 text-lg">
                                    Redirection vers votre espace sécurisé...
                                </p>
                            </motion.div>
                        )}
                    </AnimatePresence>
                </div>

                {/* Right Column: Dynamic Content */}
                <div className="w-full md:w-1/2 lg:w-7/12 mt-8 md:mt-0">
                    <Card className="bg-white border-none shadow-xl overflow-hidden min-h-[500px] flex flex-col relative group">
                        <div className="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent z-10" />
                        <Image
                            src="/images/bank_ad.png"
                            alt="Business Meeting"
                            fill
                            className="object-cover group-hover:scale-105 transition-transform duration-700"
                        />
                        <div className="absolute bottom-0 left-0 p-8 z-20 text-white space-y-4 max-w-lg">
                            <div className="inline-block px-3 py-1 bg-bnp-emerald text-white text-xs font-bold rounded uppercase tracking-wider">
                                International
                            </div>
                            <h3 className="text-3xl font-bold leading-tight">
                                Importateurs : découvrez l'option UPAS !
                            </h3>
                            <p className="text-gray-200">
                                La clause UPAS insérée dans vos crédits documentaires vous permet d'optimiser les conditions de paiement de vos importations.
                            </p>
                            <Button className="bg-white text-bnp-emerald hover:bg-gray-100 border-none mt-4 w-auto self-start px-6">
                                En savoir plus <ArrowRight className="w-4 h-4 ml-2" />
                            </Button>
                        </div>
                    </Card>

                    <div className="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">
                        <Card className="bg-white p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer">
                            <div className="w-2 h-2 rounded-full bg-yellow-400 mb-4" />
                            <h4 className="font-bold text-gray-900 mb-2">La prévoyance Dirigeant</h4>
                            <p className="text-sm text-gray-500">Protégez ce qui vous est cher avec nos solutions sur mesure.</p>
                        </Card>
                        <Card className="bg-white p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer">
                            <div className="w-2 h-2 rounded-full bg-blue-400 mb-4" />
                            <h4 className="font-bold text-gray-900 mb-2">Signature Électronique</h4>
                            <p className="text-sm text-gray-500">Facilitez-vous la vie avec la signature électronique sécurisée.</p>
                        </Card>
                    </div>
                </div>
            </main >
        </div >
    )
}
