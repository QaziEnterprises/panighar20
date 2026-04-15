CREATE TYPE public.app_role AS ENUM ('admin', 'user');

CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role app_role NOT NULL DEFAULT 'user',
  UNIQUE(user_id, role)
);
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role)
$$;

CREATE POLICY "Users can read own roles" ON public.user_roles FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Admins can manage roles" ON public.user_roles FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin'));

CREATE TABLE public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  display_name TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read own profile" ON public.profiles FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE TABLE public.app_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT NOT NULL UNIQUE,
  value TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can read settings" ON public.app_settings FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admins can manage settings" ON public.app_settings FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin'));

CREATE TABLE public.audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  user_email TEXT,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  description TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can read audit logs" ON public.audit_logs FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated can insert audit logs" ON public.audit_logs FOR INSERT TO authenticated WITH CHECK (true);

CREATE TABLE public.backup_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  file_name TEXT NOT NULL,
  file_id TEXT,
  status TEXT DEFAULT 'pending',
  type TEXT DEFAULT 'manual',
  error_message TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.backup_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own backups" ON public.backup_history FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE TABLE public.contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  address TEXT,
  city TEXT,
  opening_balance NUMERIC DEFAULT 0,
  current_balance NUMERIC DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage contacts" ON public.contacts FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.product_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage product categories" ON public.product_categories FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  sku TEXT,
  category_id UUID REFERENCES public.product_categories(id),
  purchase_price NUMERIC DEFAULT 0,
  selling_price NUMERIC DEFAULT 0,
  quantity NUMERIC DEFAULT 0,
  unit TEXT,
  alert_threshold NUMERIC DEFAULT 5,
  brand TEXT,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage products" ON public.products FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.expense_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.expense_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage expense categories" ON public.expense_categories FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID REFERENCES public.expense_categories(id),
  amount NUMERIC NOT NULL,
  date DATE DEFAULT CURRENT_DATE,
  description TEXT,
  payment_method TEXT,
  reference_no TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage expenses" ON public.expenses FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.sales (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contact_id UUID REFERENCES public.contacts(id),
  date DATE DEFAULT CURRENT_DATE,
  bill_no TEXT,
  total_amount NUMERIC DEFAULT 0,
  discount NUMERIC DEFAULT 0,
  net_amount NUMERIC DEFAULT 0,
  payment_method TEXT DEFAULT 'cash',
  payment_status TEXT DEFAULT 'paid',
  notes TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage sales" ON public.sales FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.sale_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sale_id UUID NOT NULL REFERENCES public.sales(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id),
  quantity NUMERIC DEFAULT 1,
  unit_price NUMERIC DEFAULT 0,
  subtotal NUMERIC DEFAULT 0
);
ALTER TABLE public.sale_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage sale items" ON public.sale_items FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contact_id UUID REFERENCES public.contacts(id),
  date DATE DEFAULT CURRENT_DATE,
  invoice_no TEXT,
  total_amount NUMERIC DEFAULT 0,
  discount NUMERIC DEFAULT 0,
  net_amount NUMERIC DEFAULT 0,
  payment_method TEXT DEFAULT 'cash',
  payment_status TEXT DEFAULT 'paid',
  notes TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage purchases" ON public.purchases FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.purchase_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  purchase_id UUID NOT NULL REFERENCES public.purchases(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id),
  quantity NUMERIC DEFAULT 1,
  unit_price NUMERIC DEFAULT 0,
  subtotal NUMERIC DEFAULT 0
);
ALTER TABLE public.purchase_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage purchase items" ON public.purchase_items FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.ledger_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contact_id UUID NOT NULL REFERENCES public.contacts(id),
  date DATE DEFAULT CURRENT_DATE,
  description TEXT NOT NULL,
  debit NUMERIC DEFAULT 0,
  credit NUMERIC DEFAULT 0,
  balance NUMERIC DEFAULT 0,
  reference_type TEXT,
  reference_id TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.ledger_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage ledger entries" ON public.ledger_entries FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.daily_summaries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date DATE NOT NULL UNIQUE,
  total_sales NUMERIC DEFAULT 0,
  total_purchases NUMERIC DEFAULT 0,
  total_expenses NUMERIC DEFAULT 0,
  net_profit NUMERIC DEFAULT 0,
  sales_count INTEGER DEFAULT 0,
  purchases_count INTEGER DEFAULT 0,
  expenses_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.daily_summaries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage daily summaries" ON public.daily_summaries FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.cash_register (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date DATE DEFAULT CURRENT_DATE,
  opening_balance NUMERIC DEFAULT 0,
  cash_in NUMERIC DEFAULT 0,
  cash_out NUMERIC DEFAULT 0,
  expected_balance NUMERIC DEFAULT 0,
  actual_balance NUMERIC,
  discrepancy NUMERIC,
  notes TEXT,
  status TEXT DEFAULT 'open',
  opened_by UUID REFERENCES auth.users(id),
  closed_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.cash_register ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage cash register" ON public.cash_register FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.price_lists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.price_lists ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage price lists" ON public.price_lists FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.price_list_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  price_list_id UUID NOT NULL REFERENCES public.price_lists(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES public.products(id),
  custom_price NUMERIC DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.price_list_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated can manage price list items" ON public.price_list_items FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.login_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  identifier TEXT NOT NULL,
  attempted_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.login_attempts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can insert login attempts" ON public.login_attempts FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can read login attempts" ON public.login_attempts FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'));

CREATE TABLE public.google_drive_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  access_token TEXT NOT NULL,
  refresh_token TEXT NOT NULL,
  expiry_date BIGINT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.google_drive_tokens ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own tokens" ON public.google_drive_tokens FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, display_name)
  VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)));
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'user');
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $$ LANGUAGE plpgsql SET search_path = public;

CREATE TRIGGER update_contacts_updated_at BEFORE UPDATE ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_sales_updated_at BEFORE UPDATE ON public.sales FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_purchases_updated_at BEFORE UPDATE ON public.purchases FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_cash_register_updated_at BEFORE UPDATE ON public.cash_register FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_daily_summaries_updated_at BEFORE UPDATE ON public.daily_summaries FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_price_lists_updated_at BEFORE UPDATE ON public.price_lists FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();