import { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import {
  Droplets, Shield, Wrench, Truck, Phone, Mail, MapPin, Star,
  ChevronRight, Package, Users, Award, Clock, CheckCircle2, Heart,
  Menu, X, ArrowRight, Sparkles, Globe
} from "lucide-react";

const NAV_LINKS = [
  { label: "Home", href: "#hero" },
  { label: "About", href: "#about" },
  { label: "Services", href: "#services" },
  { label: "Products", href: "#products" },
  { label: "Reviews", href: "#reviews" },
  { label: "FAQ", href: "#faq" },
  { label: "Contact", href: "#contact" },
];

const SERVICES = [
  { icon: Droplets, title: "Domestic Water Filtration", desc: "Complete home water purification systems ensuring safe, clean drinking water for your family." },
  { icon: Shield, title: "Commercial Water Plants", desc: "Industrial-grade water treatment plants for businesses, factories, and commercial establishments." },
  { icon: Package, title: "Water Bottles & Accessories", desc: "Premium empty water bottles, seals, caps, and all bottle accessories at wholesale rates." },
  { icon: Wrench, title: "Plant Accessories & Parts", desc: "All types of water filtration plant accessories, spare parts, and maintenance supplies." },
  { icon: Truck, title: "Delivery & Installation", desc: "Professional delivery and installation services across Bahawalpur and surrounding areas." },
  { icon: Clock, title: "24/7 Customer Support", desc: "Round-the-clock technical support and after-sales service for all our products." },
];

const PRODUCTS = [
  { name: "Domestic RO Plants", desc: "Home reverse osmosis systems for pure drinking water", price: "Starting from Rs. 15,000" },
  { name: "Commercial RO Plants", desc: "Heavy-duty plants for businesses & factories", price: "Custom Pricing" },
  { name: "Water Bottles (19L)", desc: "Empty 19-liter reusable water bottles", price: "Wholesale Rates" },
  { name: "Bottle Seals & Caps", desc: "Heat-shrink seals and caps for water bottles", price: "Bulk Available" },
  { name: "Filters & Membranes", desc: "Replacement filters, membranes, and cartridges", price: "All Brands" },
  { name: "Plant Spare Parts", desc: "Pumps, housings, fittings & all accessories", price: "Best Prices" },
];

const REVIEWS = [
  { name: "Ahmed Khan", role: "Restaurant Owner", text: "PaniGhar installed a commercial RO plant for our restaurant. Water quality is excellent and their after-sales service is outstanding!", rating: 5 },
  { name: "Dr. Fatima Noor", role: "Clinic Owner", text: "We've been using their domestic filtration system for 2 years. Best investment for our family's health. Highly recommended!", rating: 5 },
  { name: "Muhammad Arif", role: "Water Business Owner", text: "Great wholesale prices on bottles and accessories. They are our go-to supplier for everything water-related.", rating: 5 },
  { name: "Haji Rasheed", role: "School Administrator", text: "PaniGhar provided water plants for our school. Professional installation and regular maintenance. Very trustworthy.", rating: 5 },
  { name: "Sana Malik", role: "Homeowner", text: "Affordable, reliable, and the team is very knowledgeable. They helped us choose the perfect system for our home.", rating: 5 },
  { name: "Bilal Hussain", role: "Factory Manager", text: "Their commercial water treatment solution solved our water quality issues completely. Excellent technical expertise!", rating: 4 },
];

const FAQS = [
  { q: "What types of water filtration systems do you offer?", a: "We offer both domestic (home) and commercial (industrial) water filtration plants including RO systems, UV purifiers, and multi-stage filtration systems suitable for any scale." },
  { q: "Do you provide installation services?", a: "Yes! We provide free installation with every water plant purchase. Our trained technicians ensure proper setup and test water quality before handover." },
  { q: "What is the warranty on your products?", a: "All our water plants come with a minimum 1-year warranty on parts and labor. Extended warranty options are also available." },
  { q: "Do you sell water bottles in bulk?", a: "Absolutely! We supply empty 19-liter water bottles, seals, caps, and all related accessories at competitive wholesale prices. Bulk orders get special discounts." },
  { q: "How often should filters be replaced?", a: "Typically, sediment filters should be replaced every 3-6 months, carbon filters every 6-12 months, and RO membranes every 2-3 years depending on water quality and usage." },
  { q: "Do you offer maintenance contracts?", a: "Yes, we offer annual maintenance contracts (AMC) that include regular servicing, filter replacements, and priority support. Contact us for customized plans." },
  { q: "What areas do you serve?", a: "We primarily serve Bahawalpur and surrounding districts. For large commercial orders, we can arrange delivery across South Punjab." },
];

const STATS = [
  { value: "500+", label: "Plants Installed" },
  { value: "1000+", label: "Happy Customers" },
  { value: "5+", label: "Years Experience" },
  { value: "24/7", label: "Support Available" },
];

export default function HomePage() {
  const [mobileMenu, setMobileMenu] = useState(false);

  const scrollTo = (id: string) => {
    setMobileMenu(false);
    document.querySelector(id)?.scrollIntoView({ behavior: "smooth" });
  };

  return (
    <div className="min-h-screen bg-background text-foreground">
      {/* Navbar */}
      <nav className="fixed top-0 left-0 right-0 z-50 bg-card/90 backdrop-blur-md border-b border-border shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 flex items-center justify-between h-16">
          <button onClick={() => scrollTo("#hero")} className="flex items-center gap-2 font-bold text-xl text-primary">
            <Droplets className="h-7 w-7" />
            <span>PaniGhar</span>
          </button>
          <div className="hidden md:flex items-center gap-6">
            {NAV_LINKS.map((l) => (
              <button key={l.href} onClick={() => scrollTo(l.href)} className="text-sm font-medium text-muted-foreground hover:text-primary transition-colors">
                {l.label}
              </button>
            ))}
            <Link to="/login">
              <Button size="sm">Dashboard Login</Button>
            </Link>
          </div>
          <button className="md:hidden p-2" onClick={() => setMobileMenu(!mobileMenu)}>
            {mobileMenu ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
          </button>
        </div>
        {mobileMenu && (
          <div className="md:hidden bg-card border-t border-border px-4 py-4 space-y-3">
            {NAV_LINKS.map((l) => (
              <button key={l.href} onClick={() => scrollTo(l.href)} className="block w-full text-left text-sm font-medium text-muted-foreground hover:text-primary">
                {l.label}
              </button>
            ))}
            <Link to="/login" className="block">
              <Button size="sm" className="w-full">Dashboard Login</Button>
            </Link>
          </div>
        )}
      </nav>

      {/* Hero */}
      <section id="hero" className="pt-24 pb-16 md:pt-32 md:pb-24 bg-gradient-to-br from-primary/10 via-background to-accent/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 flex flex-col md:flex-row items-center gap-10">
          <div className="flex-1 space-y-6">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-primary/10 text-primary text-xs font-semibold">
              <Sparkles className="h-3.5 w-3.5" /> Trusted Water Solutions Since 2019
            </div>
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold leading-tight text-foreground">
              Pure Water,{" "}
              <span className="text-primary">Healthy Life</span>
            </h1>
            <p className="text-lg text-muted-foreground max-w-xl">
              PaniGhar Water Care Treatment Technology — your trusted partner for domestic &amp; commercial water filtration plants, bottles, accessories and complete water solutions in Bahawalpur.
            </p>
            <div className="flex flex-wrap gap-3">
              <Button size="lg" onClick={() => scrollTo("#contact")} className="gap-2">
                Get a Free Quote <ArrowRight className="h-4 w-4" />
              </Button>
              <Button size="lg" variant="outline" onClick={() => scrollTo("#products")} className="gap-2">
                View Products <ChevronRight className="h-4 w-4" />
              </Button>
            </div>
            <div className="flex items-center gap-4 pt-2">
              <a href="tel:03000317383" className="flex items-center gap-2 text-sm font-medium text-muted-foreground hover:text-primary transition-colors">
                <Phone className="h-4 w-4" /> 0300-0317383
              </a>
              <a href="tel:03007811479" className="flex items-center gap-2 text-sm font-medium text-muted-foreground hover:text-primary transition-colors">
                <Phone className="h-4 w-4" /> 0300-7811479
              </a>
            </div>
          </div>
          <div className="flex-1 flex justify-center">
            <div className="relative w-72 h-72 md:w-96 md:h-96 rounded-full bg-gradient-to-br from-primary/20 to-accent/20 flex items-center justify-center">
              <Droplets className="h-32 w-32 md:h-44 md:w-44 text-primary/60" />
              <div className="absolute -top-2 -right-2 bg-primary text-primary-foreground rounded-full px-3 py-1 text-xs font-bold shadow-lg">
                ISO Certified
              </div>
              <div className="absolute -bottom-2 -left-2 bg-accent text-accent-foreground rounded-full px-3 py-1 text-xs font-bold shadow-lg">
                5+ Years
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Stats */}
      <section className="py-10 bg-primary text-primary-foreground">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
          {STATS.map((s) => (
            <div key={s.label}>
              <div className="text-3xl md:text-4xl font-extrabold">{s.value}</div>
              <div className="text-sm opacity-80 mt-1">{s.label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* About */}
      <section id="about" className="py-16 md:py-24">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <div className="text-center max-w-3xl mx-auto mb-12">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">About <span className="text-primary">PaniGhar</span></h2>
            <p className="text-muted-foreground text-lg">
              PaniGhar Water Care Treatment Technology is a Bahawalpur-based company specializing in water purification solutions. We provide high-quality domestic and commercial water filtration plants, empty water bottles, bottle accessories (seals, caps), and plant spare parts. Our mission is to make clean, safe drinking water accessible and affordable for everyone.
            </p>
          </div>
          <div className="grid md:grid-cols-3 gap-6">
            {[
              { icon: Award, title: "Quality Assured", desc: "We use only certified, high-grade components in all our water treatment systems." },
              { icon: Users, title: "Customer First", desc: "Our dedicated team provides personalized solutions tailored to your specific water needs." },
              { icon: Globe, title: "Wide Coverage", desc: "Serving Bahawalpur and surrounding districts with reliable delivery and installation." },
            ].map((item) => (
              <Card key={item.title} className="text-center p-6 hover:shadow-lg transition-shadow border-border">
                <item.icon className="h-10 w-10 text-primary mx-auto mb-4" />
                <h3 className="font-semibold text-lg mb-2">{item.title}</h3>
                <p className="text-muted-foreground text-sm">{item.desc}</p>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Services */}
      <section id="services" className="py-16 md:py-24 bg-muted/50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-4">Our <span className="text-primary">Services</span></h2>
          <p className="text-center text-muted-foreground mb-12 max-w-2xl mx-auto">Comprehensive water solutions from installation to maintenance — we've got you covered.</p>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {SERVICES.map((s) => (
              <Card key={s.title} className="group hover:shadow-lg hover:border-primary/30 transition-all">
                <CardContent className="p-6">
                  <div className="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center mb-4 group-hover:bg-primary/20 transition-colors">
                    <s.icon className="h-6 w-6 text-primary" />
                  </div>
                  <h3 className="font-semibold text-lg mb-2">{s.title}</h3>
                  <p className="text-muted-foreground text-sm">{s.desc}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Products */}
      <section id="products" className="py-16 md:py-24">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-4">Our <span className="text-primary">Products</span></h2>
          <p className="text-center text-muted-foreground mb-12 max-w-2xl mx-auto">Quality water treatment products and accessories at the best prices.</p>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {PRODUCTS.map((p) => (
              <Card key={p.name} className="hover:shadow-lg transition-shadow group overflow-hidden">
                <CardContent className="p-6">
                  <div className="h-40 rounded-lg bg-gradient-to-br from-primary/5 to-accent/5 flex items-center justify-center mb-4">
                    <Droplets className="h-16 w-16 text-primary/30 group-hover:text-primary/50 transition-colors" />
                  </div>
                  <h3 className="font-semibold text-lg mb-1">{p.name}</h3>
                  <p className="text-muted-foreground text-sm mb-3">{p.desc}</p>
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-bold text-primary">{p.price}</span>
                    <Button size="sm" variant="outline" onClick={() => scrollTo("#contact")} className="text-xs">
                      Inquire <ChevronRight className="h-3 w-3 ml-1" />
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Reviews */}
      <section id="reviews" className="py-16 md:py-24 bg-muted/50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-4">What Our <span className="text-primary">Customers Say</span></h2>
          <p className="text-center text-muted-foreground mb-12 max-w-2xl mx-auto">Trusted by hundreds of families and businesses across Bahawalpur.</p>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {REVIEWS.map((r, i) => (
              <Card key={i} className="hover:shadow-lg transition-shadow">
                <CardContent className="p-6">
                  <div className="flex gap-0.5 mb-3">
                    {Array.from({ length: 5 }).map((_, j) => (
                      <Star key={j} className={`h-4 w-4 ${j < r.rating ? "fill-warning text-warning" : "text-border"}`} />
                    ))}
                  </div>
                  <p className="text-sm text-muted-foreground mb-4 italic">"{r.text}"</p>
                  <div>
                    <div className="font-semibold text-sm">{r.name}</div>
                    <div className="text-xs text-muted-foreground">{r.role}</div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* FAQ */}
      <section id="faq" className="py-16 md:py-24">
        <div className="max-w-3xl mx-auto px-4 sm:px-6">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-4">Frequently Asked <span className="text-primary">Questions</span></h2>
          <p className="text-center text-muted-foreground mb-12">Everything you need to know about our products and services.</p>
          <Accordion type="single" collapsible className="space-y-2">
            {FAQS.map((f, i) => (
              <AccordionItem key={i} value={`faq-${i}`} className="border rounded-lg px-4">
                <AccordionTrigger className="text-left text-sm font-medium hover:no-underline">
                  {f.q}
                </AccordionTrigger>
                <AccordionContent className="text-muted-foreground text-sm">
                  {f.a}
                </AccordionContent>
              </AccordionItem>
            ))}
          </Accordion>
        </div>
      </section>

      {/* Contact */}
      <section id="contact" className="py-16 md:py-24 bg-primary/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-12">Get In <span className="text-primary">Touch</span></h2>
          <div className="grid md:grid-cols-2 gap-10">
            <div className="space-y-6">
              <h3 className="text-xl font-semibold">Contact Information</h3>
              <div className="space-y-4">
                <a href="tel:03000317383" className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors">
                  <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center"><Phone className="h-5 w-5 text-primary" /></div>
                  <div><div className="text-xs text-muted-foreground">Phone 1</div><div className="font-medium text-foreground">0300-0317383</div></div>
                </a>
                <a href="tel:03007811479" className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors">
                  <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center"><Phone className="h-5 w-5 text-primary" /></div>
                  <div><div className="text-xs text-muted-foreground">Phone 2</div><div className="font-medium text-foreground">0300-7811479</div></div>
                </a>
                <a href="mailto:imrankhalilqazi@gmail.com" className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors">
                  <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center"><Mail className="h-5 w-5 text-primary" /></div>
                  <div><div className="text-xs text-muted-foreground">Email 1</div><div className="font-medium text-foreground">imrankhalilqazi@gmail.com</div></div>
                </a>
                <a href="mailto:muazbinshafi@gmail.com" className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors">
                  <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center"><Mail className="h-5 w-5 text-primary" /></div>
                  <div><div className="text-xs text-muted-foreground">Email 2</div><div className="font-medium text-foreground">muazbinshafi@gmail.com</div></div>
                </a>
                <div className="flex items-start gap-3">
                  <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center shrink-0"><MapPin className="h-5 w-5 text-primary" /></div>
                  <div><div className="text-xs text-muted-foreground">Address</div><div className="font-medium text-foreground">Al Hafeez Manzil, Darbar Mahal Road, Near University Chowk, Bahawalpur</div></div>
                </div>
              </div>
            </div>
            <Card className="p-6">
              <h3 className="text-xl font-semibold mb-4">Send Us a Message</h3>
              <form onSubmit={(e) => { e.preventDefault(); window.open(`https://wa.me/923000317383?text=${encodeURIComponent("Hi PaniGhar, I'm interested in your water solutions.")}`, "_blank"); }} className="space-y-4">
                <div>
                  <label className="text-sm font-medium mb-1 block">Name</label>
                  <input type="text" placeholder="Your Name" className="w-full rounded-lg border border-input bg-background px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-ring" />
                </div>
                <div>
                  <label className="text-sm font-medium mb-1 block">Phone</label>
                  <input type="tel" placeholder="Your Phone Number" className="w-full rounded-lg border border-input bg-background px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-ring" />
                </div>
                <div>
                  <label className="text-sm font-medium mb-1 block">Message</label>
                  <textarea placeholder="How can we help you?" rows={4} className="w-full rounded-lg border border-input bg-background px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-ring resize-none" />
                </div>
                <Button type="submit" className="w-full gap-2">
                  Send via WhatsApp <ArrowRight className="h-4 w-4" />
                </Button>
              </form>
            </Card>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-foreground text-background py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <div className="grid md:grid-cols-3 gap-8 mb-8">
            <div>
              <div className="flex items-center gap-2 font-bold text-xl mb-3">
                <Droplets className="h-6 w-6" /> PaniGhar
              </div>
              <p className="text-sm opacity-70">
                Water Care Treatment Technology — providing clean water solutions for homes and businesses in Bahawalpur since 2019.
              </p>
            </div>
            <div>
              <h4 className="font-semibold mb-3">Quick Links</h4>
              <div className="space-y-2">
                {NAV_LINKS.map((l) => (
                  <button key={l.href} onClick={() => scrollTo(l.href)} className="block text-sm opacity-70 hover:opacity-100 transition-opacity">
                    {l.label}
                  </button>
                ))}
              </div>
            </div>
            <div>
              <h4 className="font-semibold mb-3">Contact</h4>
              <div className="space-y-2 text-sm opacity-70">
                <div>0300-0317383 | 0300-7811479</div>
                <div>imrankhalilqazi@gmail.com</div>
                <div>muazbinshafi@gmail.com</div>
                <div>Al Hafeez Manzil, Darbar Mahal Road, Near University Chowk, Bahawalpur</div>
              </div>
            </div>
          </div>
          <div className="border-t border-background/20 pt-6 text-center text-sm opacity-60">
            <p>© {new Date().getFullYear()} PaniGhar Water Care Treatment Technology. All rights reserved.</p>
            <p className="mt-2 flex items-center justify-center gap-1">
              Made by <span className="font-semibold">MuazBinShafi</span> with <Heart className="h-4 w-4 fill-destructive text-destructive inline" /> using <span className="font-semibold">Lovable</span>
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
